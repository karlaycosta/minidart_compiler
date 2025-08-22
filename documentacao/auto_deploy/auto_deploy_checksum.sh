#!/bin/bash
# ─────────────────────────────────────────────────────────────
#  LiPo Deploy v4.1 - Deploy Automático para Netlify
#  Autor: Stella
#  Data: 2025-08-16
#  Descrição: Monitoramento e deploy automático com painel limpo
# ─────────────────────────────────────────────────────────────

# ---------------- CONFIGURAÇÃO ----------------
SITE_DIR="$(realpath "$(dirname "$0")/../site")"
CHECKSUM_FILE="$(dirname "$0")/.deploy_checksums"
LAST_CHECKSUM_FILE="$(dirname "$0")/.last_checksums"
LAST_DEPLOY_FILE="$(dirname "$0")/.last_deploy_checksum"
CHECK_INTERVAL=${CHECK_INTERVAL:-10}  # em segundos, padrão 10
SITE_ID="8ba5630d-2544-4805-b0a1-38fcd5b83dbf"
LOG_FILE="$(dirname "$0")/deploy.log"

# ---------------- VARIÁVEIS ----------------
success=0
fail=0

# ======================================================
# Cabeçalho inicial do log (somente se não existir)
# ======================================================
init_log() {
    if [[ ! -f "$LOG_FILE" ]]; then
        {
            echo "╔═════════════════════╦═════════════════════╦═════════╦════════════════════════════════════════════════════════╗"
            echo "║ DATA/HORA           │ ARQUIVOS ALTERADOS  │ STATUS  │ MENSAGEM                                               ║"
            echo "╠═════════════════════╬═════════════════════╬═════════╬════════════════════════════════════════════════════════╣"
            echo "╚═════════════════════╩═════════════════════╩═════════╩════════════════════════════════════════════════════════╝"
        } > "$LOG_FILE"
    fi
}

# ======================================================
# Carrega estatísticas do log existente
# ======================================================
load_stats() {
    success=$(grep -c "║ .* │ .* │ SUCESSO" "$LOG_FILE" 2>/dev/null)
    fail=$(grep -c "║ .* │ .* │ FALHA" "$LOG_FILE" 2>/dev/null)
    success=${success:-0}
    fail=${fail:-0}
}

# ======================================================
# Registra eventos no log
# ======================================================
log_event() {
    local status="$1"
    local message="$2"
    local changes="$3"
    local timestamp
    timestamp=$(date "+%d/%m/%Y %H:%M:%S")
    
    # Remove rodapé
    sed -i '/^╚/d' "$LOG_FILE"

    # Adiciona linha formatada
    printf "║ %-19s │ %-17s │ %-7s │ %-54s ║\n" \
        "$timestamp" "$changes" "$status" "$message" >> "$LOG_FILE"

    # Reinsere rodapé
    echo "╚═════════════════════╩═════════════════════╩═════════╩════════════════════════════════════════════════════════╝" >> "$LOG_FILE"
}

# ======================================================
# Função auxiliar para registro simplificado
# ======================================================
record_deploy() {
    local status="$1"
    local message="$2"
    local changes="$3"

    log_event "$status" "$message" "$changes"
    if [[ "$status" == "SUCESSO" ]]; then
        ((success++))
    else
        ((fail++))
    fi
}

# ======================================================
# Banner
# ======================================================
banner() {
    echo "╭──────────────────────────────────────────────╮"
    echo "│        LiPo Deploy - Deploy Automático       │"
    echo "╰──────────────────────────────────────────────╯"
}

# ======================================================
# Mostra estatísticas
# ======================================================
show_stats() {
    local total=$((success + fail))
    local rate=0
    [[ $total -gt 0 ]] && rate=$((success * 100 / total))

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    printf "Total Deploys : %d\n" "$total"
    printf "Com Sucesso   : %d\n" "$success"
    printf "Falhas        : %d\n" "$fail"
    printf "Taxa Sucesso  : %d%%\n" "$rate"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# ======================================================
# Verifica alterações e retorna tipo de mudança
# ======================================================
check_changes() {
    sha1sum "$SITE_DIR"/* 2>/dev/null | sort > "$CHECKSUM_FILE.tmp"

    if [[ -f "$CHECKSUM_FILE" ]]; then
        sort "$CHECKSUM_FILE" -o "$CHECKSUM_FILE"
        local changed removed
        changed=$(comm -13 "$CHECKSUM_FILE" "$CHECKSUM_FILE.tmp" | wc -l)
        removed=$(comm -23 "$CHECKSUM_FILE" "$CHECKSUM_FILE.tmp" | wc -l)
        cp "$CHECKSUM_FILE" "$LAST_CHECKSUM_FILE"
        mv "$CHECKSUM_FILE.tmp" "$CHECKSUM_FILE"

        [[ $changed -gt 0 || $removed -gt 0 ]] && echo "changed" || echo "no"
    else
        mv "$CHECKSUM_FILE.tmp" "$CHECKSUM_FILE"
        echo "first"
    fi
}

# ======================================================
# Retorna mensagem detalhada sobre alterações
# ======================================================
get_changes_message() {
    case "$1" in
        no) echo "Sem mudanças" ;;
        changed) echo "Alterado" ;;
        first) echo "Primeiro deploy" ;;
    esac
}

# ======================================================
# Deploy do site
# ======================================================
deploy_site() {
    if [[ ! -d "$SITE_DIR" ]]; then
        record_deploy "FALHA" "Deploy falhou: pasta '${SITE_DIR}' não encontrada" "Desconhecido"
        return 1
    fi

    local output
    output=$(netlify deploy --prod --site="$SITE_ID" --dir="$SITE_DIR" --no-build 2>&1)
    local status=$?

    if [[ $status -eq 0 ]]; then
        cp "$CHECKSUM_FILE" "$LAST_DEPLOY_FILE"
        record_deploy "SUCESSO" "Deploy OK - URL: https://documentacao-lipo.netlify.app" "$(get_changes_message "$result")"
    else
        echo "$output" >> "$LOG_FILE"  # salva log completo do erro
        record_deploy "FALHA" "Build falhou" "$(get_changes_message "$result")"
    fi
}

# ======================================================
# Barra de progresso leve
# ======================================================
progress_bar() {
    local duration=$1
    local elapsed=0
    local bar_length=40

    while [[ $elapsed -lt $duration ]]; do
        local percent=$(( elapsed * 100 / duration ))
        printf "\rProgresso: [%-40s] %3d%%" "$(printf "%0.s#" $(seq 1 $((percent * bar_length / 100))))" "$percent"
        sleep 1
        ((elapsed++))
    done
    echo ""
}

# ======================================================
# Finalizar manualmente
# ======================================================
finalizar() {
    echo -e "\n╔════════════════════════════════════════════════════════════════╗"
    echo -e "║                       Monitoramento encerrado                  ║"
    echo -e "╚════════════════════════════════════════════════════════════════╝"
    read -p "Pressione Enter para continuar..."
    clear
    exit 0
}
trap finalizar SIGINT

# ======================================================
# Loop principal
# ======================================================
main_loop() {
    init_log
    load_stats

    while true; do
        clear
        banner
        result=$(check_changes)
        deploy_site
        show_stats
        local next_time=$(date -d "+$CHECK_INTERVAL seconds" "+%H:%M:%S")
        echo "Próxima verificação às $next_time (em $((CHECK_INTERVAL/60)) minutos)..."
        progress_bar "$CHECK_INTERVAL"
    done
}

main_loop
