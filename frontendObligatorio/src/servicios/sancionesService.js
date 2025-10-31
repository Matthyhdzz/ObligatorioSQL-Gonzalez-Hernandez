export async function obtenerSanciones() {
  try {
    const response = await fetch("http://localhost:5000/sancion_participante");
    if (!response.ok) {
      throw new Error("Error al obtener las sanciones");
    }
    const data = await response.json();
    return data;
  } catch (error) {
    console.error("Error al obtener sanciones:", error);
    return [];
  }
}
