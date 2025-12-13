import rive from 'libohos_rive.so';
export function initializeRive() {
  try {
    rive.Napi_Rive_cppInitialize();
    console.info("Rive initialized successfully!");
  } catch (e) {
    console.error("Rive initialization failed: " + e.message);
  }
}