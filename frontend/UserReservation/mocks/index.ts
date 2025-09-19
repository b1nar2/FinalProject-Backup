export async function enableMocking() {
  if (!import.meta.env.DEV) return;
  const { worker } = await import("./browser");
  await worker.start({
    serviceWorker: {
      url: `${import.meta.env.BASE_URL}mockServiceWorker.js`, // Vite base 대응
    },
  });
}
