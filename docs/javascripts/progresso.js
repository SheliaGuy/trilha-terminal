// Guarda no navegador quais itens das listas "Você consegue..." foram marcados.
// É só uma conveniência de estudo: o progresso oficial é o PROGRESSO.md do seu repo.
(function () {
  function chave(i) {
    return "trilha:" + location.pathname + ":" + i;
  }
  function ler(k) {
    try { return localStorage.getItem(k); } catch (e) { return null; }
  }
  function gravar(k, v) {
    try { v ? localStorage.setItem(k, "1") : localStorage.removeItem(k); } catch (e) {}
  }
  function montar() {
    var caixas = document.querySelectorAll(".md-content .task-list-control input[type=checkbox]");
    caixas.forEach(function (cx, i) {
      cx.disabled = false;
      cx.checked = ler(chave(i)) === "1";
      cx.addEventListener("change", function () { gravar(chave(i), cx.checked); });
    });
  }
  // Material usa navegação instantânea quando ativada; document$ cobre os dois casos.
  if (window.document$ && window.document$.subscribe) {
    window.document$.subscribe(montar);
  } else {
    document.addEventListener("DOMContentLoaded", montar);
  }
})();
