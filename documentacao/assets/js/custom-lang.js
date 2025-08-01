document.addEventListener("DOMContentLoaded", function () {
  const replacements = {
    "On This Page": "Nesta Página",
    "Edit this page": "Editar esta página",
    "Search": "Buscar...",
    "No results found.": "Nenhum resultado encontrado.",
    "Last updated": "Última atualização",
    "Back to top": "Voltar ao topo"
  };

  const replaceText = () => {
    for (const [en, pt] of Object.entries(replacements)) {
      const elements = document.querySelectorAll('*');
      elements.forEach(el => {
        if (el.childNodes.length === 1 && el.textContent.trim() === en) {
          el.textContent = pt;
        }
      });
    }
  };

  replaceText();
});
