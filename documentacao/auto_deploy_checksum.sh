#!/bin/bash

# =============================================================================
# LiPo Deploy - Sistema Automatizado de Deploy
# Versão: 3.0 (Beautiful Terminal Design)
# =============================================================================

set -euo pipefail  # Modo strict

# =============================================================================
# CONFIGURAÇÕES
# =============================================================================

readonly CHECKSUM_FILE=".last_deploy_checksum"
readonly LOG_FILE="deploy.log"
readonly CHANGES_FILE=".deploy_changes"
readonly SLEEP_INTERVAL=180
readonly VERSION="3.0"

# =============================================================================
# CORES E ESTILOS
# =============================================================================

declare -A COLORS=(
    [RESET]='\033[0m'
    [BOLD]='\033[1m'
    [DIM]='\033[2m'
    [UNDERLINE]='\033[4m'
    
    # Cores principais
    [RED]='\033[0;31m'
    [GREEN]='\033[0;32m'
    [YELLOW]='\033[0;33m'
    [BLUE]='\033[0;34m'
    [PURPLE]='\033[0;35m'
    [CYAN]='\033[0;36m'
    [WHITE]='\033[0;37m'
    [GRAY]='\033[0;90m'
    
    # Cores brilhantes
    [BRIGHT_RED]='\033[1;31m'
    [BRIGHT_GREEN]='\033[1;32m'
    [BRIGHT_YELLOW]='\033[1;33m'
    [BRIGHT_BLUE]='\033[1;34m'
    [BRIGHT_PURPLE]='\033[1;35m'
    [BRIGHT_CYAN]='\033[1;36m'
    [BRIGHT_WHITE]='\033[1;37m'
    
    # Backgrounds
    [BG_RED]='\033[41m'
    [BG_GREEN]='\033[42m'
    [BG_YELLOW]='\033[43m'
    [BG_BLUE]='\033[44m'
    [BG_PURPLE]='\033[45m'
    [BG_CYAN]='\033[46m'
    [BG_WHITE]='\033[47m'
    [BG_GRAY]='\033[100m'
)

# =============================================================================
# UTILITÁRIOS DE DISPLAY
# =============================================================================

# Função para colorir texto
colorize() {
    local color=$1
    local text=$2
    echo -e "${COLORS[$color]}${text}${COLORS[RESET]}"
}

# Função para criar linha decorativa
draw_line() {
    local char=${1:-"─"}
    local length=${2:-80}
    local color=${3:-"GRAY"}
    
    printf "%s" "$(colorize "$color" "$(printf "%${length}s" | tr ' ' "$char")")"
}

# Função para criar caixa de texto
draw_box() {
    local text="$1"
    local color=${2:-"CYAN"}
    local padding=${3:-2}
    
    local text_length=${#text}
    local box_width=$((text_length + padding * 2 + 2))
    local top_line="╔$(printf "%$((box_width-2))s" | tr ' ' '═')╗"
    local bottom_line="╚$(printf "%$((box_width-2))s" | tr ' ' '═')╝"
    local side_padding=$(printf "%${padding}s" "")
    
    echo
    colorize "$color" "$top_line"
    colorize "$color" "║${side_padding}${text}${side_padding}║"
    colorize "$color" "$bottom_line"
    echo
}

# Função para criar header principal
show_header() {
    clear
    echo
    colorize "BRIGHT_CYAN" "$(cat << 'EOF'
    ╭─────────────────────────────────────────────────────────────────────────╮
    │                                                                         │
    │     _      _       _           _                                        │
    │    | |    (_)     | |         | |                                       │
    │    | |     _ _ __ | | ___  ___| |_ _ __ ___  ___                        │
    │    | |    | | '_ \| |/ _ \/ __| __| '__/ _ \/ _ \                       │
    │    | |____| | | | | |  __/\__ \ |_| | |  __/  __/                      │
    │    \_____/|_|_| |_|_|\___||___/\__|_|  \___|\___|                      │
    │                                                                         │
    │                 Automated Deployment System v3.0                       │
    │                                                                         │
    ╰─────────────────────────────────────────────────────────────────────────╯
EOF
)"
    echo
}

# Função para mostrar status com ícones
show_status() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%H:%M:%S')
    
    case "$level" in
        "info")
            printf "%s %s %s\n" \
                "$(colorize "BRIGHT_BLUE" "●")" \
                "$(colorize "GRAY" "[$timestamp]")" \
                "$(colorize "WHITE" "$message")"
            ;;
        "success")
            printf "%s %s %s\n" \
                "$(colorize "BRIGHT_GREEN" "✓")" \
                "$(colorize "GRAY" "[$timestamp]")" \
                "$(colorize "BRIGHT_GREEN" "$message")"
            ;;
        "warning")
            printf "%s %s %s\n" \
                "$(colorize "BRIGHT_YELLOW" "⚠")" \
                "$(colorize "GRAY" "[$timestamp]")" \
                "$(colorize "BRIGHT_YELLOW" "$message")"
            ;;
        "error")
            printf "%s %s %s\n" \
                "$(colorize "BRIGHT_RED" "✗")" \
                "$(colorize "GRAY" "[$timestamp]")" \
                "$(colorize "BRIGHT_RED" "$message")"
            ;;
        "deploy")
            printf "%s %s %s\n" \
                "$(colorize "BRIGHT_PURPLE" "▶")" \
                "$(colorize "GRAY" "[$timestamp]")" \
                "$(colorize "BRIGHT_PURPLE" "$message")"
            ;;
    esac
}

# Função para criar separador elegante
show_separator() {
    echo
    draw_line "─" 80 "GRAY"
    echo
}

# Função para mostrar progresso
show_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    printf "\r%s [%s%s] %d%% (%02d:%02d)" \
        "$(colorize "BRIGHT_BLUE" "Aguardando")" \
        "$(colorize "BRIGHT_GREEN" "$(printf "%${filled}s" | tr ' ' '█')")" \
        "$(colorize "GRAY" "$(printf "%${empty}s" | tr ' ' '░')")" \
        "$percentage" \
        "$((current / 60))" \
        "$((current % 60))"
}

# =============================================================================
# FUNÇÕES DE NEGÓCIO
# =============================================================================

# Calcular checksum dos arquivos
calculate_checksum() {
    find . -type f \
        \! -path "./.git/*" \
        \! -path "./$CHECKSUM_FILE" \
        \! -path "./$LOG_FILE" \
        \! -path "./$CHANGES_FILE" \
        \! -path "./node_modules/*" \
        \! -path "./.next/*" \
        \! -path "./dist/*" \
        \! -path "./build/*" \
        \! -path "./site/*" \
        \! -path "./.cache/*" \
        -exec md5sum {} \; 2>/dev/null | sort | md5sum | cut -d' ' -f1
}

# Detectar mudanças nos arquivos
detect_file_changes() {
    local temp_file
    temp_file=$(mktemp)
    
    find . -type f \
        \! -path "./.git/*" \
        \! -path "./$CHECKSUM_FILE" \
        \! -path "./$LOG_FILE" \
        \! -path "./$CHANGES_FILE" \
        \! -path "./node_modules/*" \
        \! -path "./.next/*" \
        \! -path "./dist/*" \
        \! -path "./build/*" \
        \! -path "./site/*" \
        \! -path "./.cache/*" \
        -exec md5sum {} \; 2>/dev/null | sort > "$temp_file"
    
    if [[ -f "$CHANGES_FILE" ]]; then
        local changed_files deleted_files total_changes
        changed_files=$(comm -13 "$CHANGES_FILE" "$temp_file" 2>/dev/null | wc -l)
        deleted_files=$(comm -23 "$CHANGES_FILE" "$temp_file" 2>/dev/null | wc -l)
        total_changes=$((changed_files + deleted_files))
        
        if [[ $total_changes -gt 0 ]]; then
            echo
            colorize "BRIGHT_WHITE" "┌─ RESUMO DAS ALTERAÇÕES ─────────────────────────────────────────────────┐"
            printf "│ %-20s: %s%-52s │\n" \
                "Arquivos novos/modificados" \
                "$(colorize "BRIGHT_GREEN" "$changed_files")" \
                ""
            printf "│ %-20s: %s%-52s │\n" \
                "Arquivos removidos" \
                "$(colorize "BRIGHT_RED" "$deleted_files")" \
                ""
            printf "│ %-20s: %s%-52s │\n" \
                "Total de alterações" \
                "$(colorize "BRIGHT_YELLOW" "$total_changes")" \
                ""
            colorize "BRIGHT_WHITE" "└─────────────────────────────────────────────────────────────────────────┘"
            
            # Mostrar arquivos alterados
            local sample_files
            sample_files=$(comm -13 "$CHANGES_FILE" "$temp_file" 2>/dev/null | head -5 | cut -d' ' -f3- | sed 's|^\./||')
            if [[ -n "$sample_files" ]]; then
                echo
                colorize "BRIGHT_CYAN" "┌─ ARQUIVOS ALTERADOS ────────────────────────────────────────────────────┐"
                while IFS= read -r file; do
                    [[ -n "$file" ]] && printf "│ %s%-71s │\n" "$(colorize "WHITE" "•")" "$file"
                done <<< "$sample_files"
                
                if [[ $changed_files -gt 5 ]]; then
                    printf "│ %s %-69s │\n" "$(colorize "GRAY" "•")" "... e mais $((changed_files - 5)) arquivo(s)"
                fi
                colorize "BRIGHT_CYAN" "└─────────────────────────────────────────────────────────────────────────┘"
            fi
            echo
        fi
    fi
    
    mv "$temp_file" "$CHANGES_FILE"
}

# Função de logging estruturado
write_log() {
    local status="$1"
    local details="$2"
    local timestamp day_name day_pt
    
    timestamp=$(date '+%d/%m/%Y %H:%M:%S')
    day_name=$(date '+%A' | tr '[:upper:]' '[:lower:]')
    
    case "$day_name" in
        "monday") day_pt="Segunda-feira" ;;
        "tuesday") day_pt="Terça-feira" ;;
        "wednesday") day_pt="Quarta-feira" ;;
        "thursday") day_pt="Quinta-feira" ;;
        "friday") day_pt="Sexta-feira" ;;
        "saturday") day_pt="Sábado" ;;
        "sunday") day_pt="Domingo" ;;
    esac
    
    # Criar cabeçalho do log se não existir
    if [[ ! -f "$LOG_FILE" ]]; then
        cat > "$LOG_FILE" << EOF
╔══════════════════════════════════════════════════════════════════════════════╗
║                          LIPO DEPLOY - LOG DE DEPLOYMENTS                   ║
║                                                                              ║
║  Este arquivo contém o histórico de todos os deployments realizados         ║
║  pelo sistema automatizado LiPo Deploy v${VERSION}.                         ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

EOF
    fi
    
    # Adicionar entrada no log
    cat >> "$LOG_FILE" << EOF
┌──────────────────────────────────────────────────────────────────────────────┐
│ DATA    : $timestamp ($day_pt)
│ STATUS  : $status
│ DETALHES: $details
└──────────────────────────────────────────────────────────────────────────────┘

EOF
}

# Executar processo de deploy
execute_deployment() {
    show_status "deploy" "Iniciando processo de deploy..."
    echo
    
    # Build
    show_status "info" "Executando build do projeto..."
    if ! docmd build > /tmp/build.log 2>&1; then
        local error_details
        error_details="$(tail -3 /tmp/build.log 2>/dev/null | tr '\n' ' ')"
        show_status "error" "Falha no processo de build"
        write_log "❌ FALHA" "Build falhou - $error_details"
        return 1
    fi
    
    show_status "success" "Build concluído com sucesso"
    
    # Deploy
    show_status "info" "Realizando deploy para produção..."
    if ! netlify deploy --prod --dir=site --no-build > /tmp/deploy.log 2>&1; then
        local error_details
        error_details="$(tail -3 /tmp/deploy.log 2>/dev/null | tr '\n' ' ')"
        show_status "error" "Falha no processo de deploy"
        write_log "❌ FALHA" "Deploy falhou - $error_details"
        return 1
    fi
    
    show_status "success" "Deploy realizado com sucesso!"
    
    # URL do deploy
    local deploy_url
    deploy_url=$(grep -o 'https://[^[:space:]]*' /tmp/deploy.log 2>/dev/null | head -1)
    if [[ -n "$deploy_url" ]]; then
        show_status "info" "URL: $(colorize "BRIGHT_BLUE" "$deploy_url")"
        write_log "✅ SUCESSO" "Deploy realizado - URL: $deploy_url"
    else
        write_log "✅ SUCESSO" "Deploy realizado com sucesso"
    fi
    
    return 0
}

# Mostrar estatísticas de deploy
show_deployment_stats() {
    if [[ ! -f "$LOG_FILE" ]]; then
        return
    fi
    
    local total_deploys successful_deploys failed_deploys success_rate
    total_deploys=$(grep -c "STATUS" "$LOG_FILE" 2>/dev/null || echo "0")
    successful_deploys=$(grep -c "✅ SUCESSO" "$LOG_FILE" 2>/dev/null || echo "0")
    failed_deploys=$(grep -c "❌ FALHA" "$LOG_FILE" 2>/dev/null || echo "0")
    success_rate=0
    
    if [[ $total_deploys -gt 0 ]]; then
        success_rate=$(( (successful_deploys * 100) / total_deploys ))
    fi
    
    echo
    colorize "BRIGHT_WHITE" "┌─ ESTATÍSTICAS DE EXECUÇÃO ──────────────────────────────────────────────┐"
    printf "│ %-25s: %s%-46s │\n" \
        "Total de Deploys" \
        "$(colorize "BRIGHT_WHITE" "$total_deploys")" \
        ""
    printf "│ %-25s: %s%-46s │\n" \
        "Deploys com Sucesso" \
        "$(colorize "BRIGHT_GREEN" "$successful_deploys")" \
        ""
    printf "│ %-25s: %s%-46s │\n" \
        "Falhas" \
        "$(colorize "BRIGHT_RED" "$failed_deploys")" \
        ""
    printf "│ %-25s: %s%-46s │\n" \
        "Taxa de Sucesso" \
        "$(colorize "BRIGHT_YELLOW" "$success_rate%")" \
        ""
    colorize "BRIGHT_WHITE" "└─────────────────────────────────────────────────────────────────────────┘"
    echo
}

# Verificar dependências do sistema
check_system_dependencies() {
    local missing_deps=()
    
    if ! command -v docmd &> /dev/null; then
        missing_deps+=("docmd")
    fi
    
    if ! command -v netlify &> /dev/null; then
        missing_deps+=("netlify")
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        show_status "error" "Dependências não encontradas: ${missing_deps[*]}"
        echo
        colorize "BRIGHT_YELLOW" "┌─ INSTRUÇÕES DE INSTALAÇÃO ──────────────────────────────────────────────┐"
        for dep in "${missing_deps[@]}"; do
            case "$dep" in
                "docmd")
                    printf "│ %-15s: %s%-56s │\n" \
                        "docmd" \
                        "$(colorize "BRIGHT_CYAN" "npm install -g docmd")" \
                        ""
                    ;;
                "netlify")
                    printf "│ %-15s: %s%-56s │\n" \
                        "netlify" \
                        "$(colorize "BRIGHT_CYAN" "npm install -g netlify-cli")" \
                        ""
                    ;;
            esac
        done
        colorize "BRIGHT_YELLOW" "└─────────────────────────────────────────────────────────────────────────┘"
        echo
        return 1
    fi
    
    return 0
}

# Mostrar mensagem de encerramento
show_exit_message() {
    clear
    echo
    draw_box "Monitoramento encerrado pelo usuário" "BRIGHT_YELLOW" 4
    draw_box "LiPo Deploy finalizado com sucesso" "BRIGHT_GREEN" 4
    echo
    colorize "GRAY" "Pressione ENTER para limpar a tela..."
    read -r
    clear
}

# =============================================================================
# FUNÇÃO PRINCIPAL
# =============================================================================

main() {
    # Verificar dependências
    show_header
    if ! check_system_dependencies; then
        exit 1
    fi
    
    show_status "info" "Iniciando monitoramento automático de alterações..."
    sleep 2
    
    # Loop principal de monitoramento
    while true; do
        show_header
        show_status "info" "Verificando alterações no projeto..."
        
        local current_checksum last_checksum
        current_checksum=$(calculate_checksum)
        last_checksum=""
        
        if [[ -f "$CHECKSUM_FILE" ]]; then
            last_checksum=$(cat "$CHECKSUM_FILE" 2>/dev/null)
        fi
        
        # Verificar alterações
        if [[ "$current_checksum" != "$last_checksum" ]]; then
            show_status "warning" "Alterações detectadas!"
            
            detect_file_changes
            
            if execute_deployment; then
                echo "$current_checksum" > "$CHECKSUM_FILE"
                local timestamp
                timestamp=$(date '+%d/%m/%Y às %H:%M:%S')
                show_separator
                show_status "success" "Deploy finalizado com sucesso em $timestamp"
            else
                show_separator
                show_status "error" "Deploy falhou. Verifique os logs para mais detalhes."
            fi
        else
            show_status "info" "Nenhuma alteração detectada."
        fi
        
        show_deployment_stats
        
        # Próxima verificação
        local next_check
        next_check=$(date -d "+$SLEEP_INTERVAL seconds" '+%H:%M:%S' 2>/dev/null || \
                    date -v+${SLEEP_INTERVAL}S '+%H:%M:%S' 2>/dev/null || \
                    echo "em breve")
        
        show_status "info" "Próxima verificação às $next_check"
        echo
        
        # Countdown com barra de progresso
        for ((i=SLEEP_INTERVAL; i>0; i--)); do
            show_progress $((SLEEP_INTERVAL - i + 1)) $SLEEP_INTERVAL
            sleep 1
        done
        
        printf "\r%80s\r" ""  # Limpar linha
    done
}

# =============================================================================
# TRATAMENTO DE SINAIS
# =============================================================================

cleanup() {
    echo
    write_log "⏹️ PARADO" "Monitoramento interrompido pelo usuário"
    show_exit_message
    exit 0
}

trap cleanup SIGINT SIGTERM

# =============================================================================
# EXECUÇÃO
# =============================================================================

main "$@"