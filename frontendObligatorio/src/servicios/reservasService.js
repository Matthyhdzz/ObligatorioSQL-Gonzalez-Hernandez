// OBTENER TODAS LAS RESERVAS
export async function obtenerReservas() {
  try {
    const response = await fetch("http://localhost:5000/reservas");
    if (!response.ok) {
      throw new Error("Error al obtener las reservas");
    }
    return await response.json();
  } catch (error) {
    console.error("Error al obtener reservas:", error);
    return [];
  }
}

// CREAR RESERVA
export async function crearReserva(reservaData) {
  try {
    const response = await fetch("http://localhost:5000/reservas", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(reservaData),
    });

    if (!response.ok) {
      const err = await response.json();
      throw new Error(err.error || "Error al crear la reserva");
    }

    return await response.json();
  } catch (error) {
    console.error("Error en crearReserva:", error);
    throw error;
  }
}

// CANCELAR RESERVA
export async function cancelarReserva(id) {
  try {
    const response = await fetch(`http://localhost:5000/reservas/${id}/cancelar`, {
      method: "PUT",
    });

    if (!response.ok) {
      const err = await response.json();
      throw new Error(err.error || "Error al cancelar la reserva");
    }

    return await response.json();
  } catch (error) {
    console.error("Error al cancelar reserva:", error);
    throw error;
  }
}


// FINALIZAR RESERVA
export async function finalizarReserva(id) {
  try {
    const response = await fetch(`http://localhost:5000/reservas/${id}/finalizar`, {
      method: "PUT",
    });

    if (!response.ok) {
      const err = await response.json();
      throw new Error(err.error || "Error al finalizar la reserva");
    }

    return await response.json();
  } catch (error) {
    console.error("Error al finalizar reserva:", error);
    throw error;
  }
}

// REGISTRAR ASISTENCIA
export async function registrarAsistencia(id_reserva, ci) {
  try {
    const response = await fetch(`http://localhost:5000/reservas/${id_reserva}/asistencia`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        ci: ci,
        asistencia: true, // Por ahora marco asistencia siempre
      }),
    });

    if (!response.ok) {
      const err = await response.json();
      throw new Error(err.error || "Error al registrar asistencia");
    }

    return await response.json();
  } catch (error) {
    console.error("Error al registrar asistencia:", error);
    throw error;
  }
}
