export async function obtenerParticipantes() {
  try {
    const response = await fetch("http://localhost:5000/participante");
    if (!response.ok) {
      throw new Error("Error al obtener los participantes");
    }
    const data = await response.json();
    return data;
  } catch (error) {
    console.error("Error al obtener participantes:", error);
    return [];
  }
}
