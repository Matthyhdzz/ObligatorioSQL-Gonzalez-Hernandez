export async function obtenerSalas() {
  try {
    const response = await fetch("http://localhost:5000/sala"); // 👈 Flask endpoint real
    if (!response.ok) {
      throw new Error("Error al obtener las salas");
    }
    const data = await response.json();
    return data;
  } catch (error) {
    console.error("Error al obtener salas:", error);
    return [];
  }
}
