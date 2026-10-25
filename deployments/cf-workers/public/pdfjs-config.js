// Strips the pdf.js viewer down to a read-only resume viewer: zoom, print and
// download. Loaded as a classic script from pdfjs/web/viewer.html so it runs
// before viewer.mjs dispatches "webviewerloaded".

// The viewer dispatches "webviewerloaded" on the parent document when it is
// embedded in a same-origin iframe, and on its own document otherwise.
const host = window.parent === window ? document : window.parent.document;

host.addEventListener("webviewerloaded", (evt) => {
  if (evt.detail?.source !== window) return;
  PDFViewerApplicationOptions.set("disablePreferences", true);
  PDFViewerApplicationOptions.set("annotationEditorMode", -1);
  PDFViewerApplicationOptions.set("sidebarViewOnLoad", 0);
});

// Swallow the viewer's shortcuts for the features hidden in pdfjs-theme.css.
// Find (Ctrl/Cmd+F, G) falls through to the browser's own find.
window.addEventListener(
  "keydown",
  (evt) => {
    const mod = evt.ctrlKey || evt.metaKey;
    const blocked =
      (mod && !evt.altKey && [70, 71, 79].includes(evt.keyCode)) ||
      (mod && evt.altKey && evt.keyCode === 80);
    if (blocked) evt.stopImmediatePropagation();
  },
  true,
);

// The phone render ("-mobile.pdf", served to phone user agents) is only for reading;
// Download still hands out the letter-size PDF.
const file = new URLSearchParams(location.search).get("file") ?? "";
const letterPdf = file.replace(/-mobile\.pdf$/, ".pdf");
if (letterPdf !== file) {
  // Switches on the phone toolbar in pdfjs-theme.css.
  document.documentElement.classList.add("phoneLayout");
  window.addEventListener(
    "click",
    (evt) => {
      if (!evt.target.closest?.("#downloadButton, #secondaryDownload")) return;
      evt.preventDefault();
      evt.stopImmediatePropagation();
      const link = document.createElement("a");
      link.href = letterPdf;
      link.download = letterPdf.split("/").pop();
      link.click();
    },
    true,
  );
}

// Block drag-and-drop of other PDFs into the viewer.
for (const type of ["dragover", "drop"]) {
  window.addEventListener(
    type,
    (evt) => {
      evt.preventDefault();
      evt.stopImmediatePropagation();
    },
    true,
  );
}
