export async function obtenerReservas() {
  try {
    const response = await fetch("http://localhost:5000/reservas"); 
    if (!response.ok) {
      throw new Error("Error al obtener las reservas");
    }
    const data = await response.json();
    return data;
  } catch (error) {
    console.error("Error al obtener reserva:", error);
    return [];
  }
}
