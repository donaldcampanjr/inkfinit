export default function App() {
  const buildTime = new Date().toLocaleString();
  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-900 text-white">
      <h1 className="text-4xl font-bold text-green-400 text-center mt-10">
        🧪 Hi, I’m STAGING — {buildTime}
      </h1>
    </div>
  );
}
