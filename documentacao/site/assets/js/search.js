import { Index } from 'flexsearch';

const index = new Index({
  tokenize: "forward",
  encode: "icase",
  cache: true,
  doc: {
    id: "path",
    field: ["title", "content"]
  }
});

let docs = [];

fetch('/search-index.json')
  .then((res) => res.json())
  .then((data) => {
    docs = data;
    index.add(data);
  });

document.addEventListener("DOMContentLoaded", () => {
  const input = document.querySelector("#searchInput");
  const resultsContainer = document.querySelector("#searchResults");

  if (!input || !resultsContainer) return;

  input.addEventListener("input", async () => {
    const query = input.value.trim();
    resultsContainer.innerHTML = "";

    if (query.length > 1) {
      const results = await index.search(query, { limit: 5, enrich: true });

      results[0].result.forEach((doc) => {
        const link = document.createElement("a");
        link.href = doc.path;
        link.textContent = doc.title;
        link.className = "search-result";
        resultsContainer.appendChild(link);
      });
    }
  });
});
