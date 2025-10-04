export default function App() {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gray-900 text-gray-100">
      <h1 className="text-5xl font-bold mb-4 flex items-center gap-2">
        <span>⚙️</span> DEV SYNC TEST
      </h1>
      <p className="text-lg text-gray-400">
        This is a lightweight layout push to verify CI/CD + staging deploy.
      </p>
      <div className="mt-6 px-4 py-2 bg-emerald-500 text-black inline-block rounded-lg font-semibold">
        LIVE SYNC TEST — {new Date().toLocaleString("en-US", { timeZone: "America/New_York" })}
      </div>
    </div>
  );
}
