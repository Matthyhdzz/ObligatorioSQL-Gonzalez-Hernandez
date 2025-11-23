import { useEffect, useState } from "react";
import { obtenerReservas, crearReserva, cancelarReserva, finalizarReserva, registrarAsistencia } from "../servicios/reservasService";
import { obtenerSalas } from "../servicios/salasService";
import { obtenerParticipantes } from "../servicios/participantesService";

export default function Reservas() {
  const [reservas, setReservas] = useState([]);
  const [salas, setSalas] = useState([]);
  const [participantes, setParticipantes] = useState([]);
  const [turnos, setTurnos] = useState([]);

  // Formulario
  const [formData, setFormData] = useState({
    nombre_sala: "",
    edificio: "",
    fecha: "",
    id_turno: "",
    participantes: [],
  });

  useEffect(() => {
    actualizarReservas();
    obtenerSalas().then(setSalas);
    obtenerParticipantes().then(setParticipantes);

    fetch("http://localhost:5000/turnos")
      .then((r) => r.json())
      .then(setTurnos);
  }, []);

  const actualizarReservas = () => {
    obtenerReservas().then(setReservas);
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    crearReserva(formData)
      .then(() => {
        alert("Reserva creada correctamente");
        actualizarReservas();
      })
      .catch((err) => alert(err.message));
  };


  // BOTONES DE ACCIONES

  const handleCancelar = (id) => {
    cancelarReserva(id)
      .then(() => {
        alert("Reserva cancelada");
        actualizarReservas();
      })
      .catch((err) => alert(err.message));
  };

  const handleFinalizar = (id) => {
    finalizarReserva(id)
      .then(() => {
        alert("Reserva finalizada");
        actualizarReservas();
      })
      .catch((err) => alert(err.message));
  };

  const handleAsistencia = (id_reserva, ci) => {
    const confirmar = window.confirm(`¿Registrar asistencia para CI ${ci}?`);
    if (!confirmar) return;

    registrarAsistencia(id_reserva, ci)
      .then(() => {
        alert("Asistencia registrada");
        actualizarReservas();
      })
      .catch((err) => alert(err.message));
  };

  return (
    <div>
      <h2>Gestión de Reservas</h2>

      {/* aca va a el form*/}
      <h3>Crear nueva reserva</h3>

      <form onSubmit={handleSubmit} style={{ marginBottom: "2rem" }}>
        <div>
          <label>Sala:</label>
          <select
            value={formData.nombre_sala}
            onChange={(e) =>
              setFormData({ ...formData, nombre_sala: e.target.value })
            }
          >
            <option value="">Seleccione</option>
            {salas.map((s) => (
              <option key={s.nombre_sala + s.edificio} value={s.nombre_sala}>
                {s.nombre_sala}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label>Edificio:</label>
          <select
            value={formData.edificio}
            onChange={(e) =>
              setFormData({ ...formData, edificio: e.target.value })
            }
          >
            <option value="">Seleccione</option>
            {salas.map((s) => (
              <option key={s.nombre_sala + s.edificio} value={s.edificio}>
                {s.edificio}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label>Fecha:</label>
          <input
            type="date"
            value={formData.fecha}
            onChange={(e) =>
              setFormData({ ...formData, fecha: e.target.value })
            }
          />
        </div>

        <div>
          <label>Turno:</label>
          <select
            value={formData.id_turno}
            onChange={(e) =>
              setFormData({ ...formData, id_turno: Number(e.target.value) })
            }
          >
            <option value="">Seleccione</option>
            {turnos.map((t) => (
              <option key={t.id_turno} value={t.id_turno}>
                {t.hora_inicio} - {t.hora_fin}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label>Participantes:</label>
          <select
            multiple
            value={formData.participantes}
            onChange={(e) =>
              setFormData({
                ...formData,
                participantes: Array.from(
                  e.target.selectedOptions,
                  (opt) => Number(opt.value)
                ),
              })
            }
          >
            {participantes.map((p) => (
              <option key={p.ci} value={p.ci}>
                {p.nombre} {p.apellido} ({p.ci})
              </option>
            ))}
          </select>
        </div>

        <button type="submit" style={{ marginTop: "1rem" }}>
          Crear reserva
        </button>
      </form>

      {/* reservas */}
      {reservas.length === 0 ? (
        <p>Cargando Reservas...</p>
      ) : (
        <table
          border="1"
          cellPadding="8"
          style={{ borderCollapse: "collapse", marginTop: "1rem" }}
        >
          <thead>
            <tr>
              <th>ID</th>
              <th>Sala</th>
              <th>Edificio</th>
              <th>Fecha</th>
              <th>Turno</th>
              <th>Estado</th>
              <th>Acciones</th>
            </tr>
          </thead>

          <tbody>
            {reservas.map((reserva) => (
              <tr key={reserva.id_reserva}>
                <td>{reserva.id_reserva}</td>
                <td>{reserva.nombre_sala}</td>
                <td>{reserva.edificio}</td>
                <td>{reserva.fecha}</td>
                <td>{reserva.id_turno}</td>
                <td>{reserva.estado}</td>

                <td>
                  <button
                    onClick={() => handleCancelar(reserva.id_reserva)}
                    disabled={reserva.estado !== "activa"}
                  >
                    Cancelar
                  </button>

                  <button
                    onClick={() => handleFinalizar(reserva.id_reserva)}
                    disabled={reserva.estado !== "activa"}
                    style={{ marginLeft: "0.5rem" }}
                  >
                    Finalizar
                  </button>

                  <button
                    onClick={() =>
                      handleAsistencia(
                        reserva.id_reserva,
                        reserva.ci_principal || 12345678
                      )
                    }
                    disabled={reserva.estado !== "activa"}
                    style={{ marginLeft: "0.5rem" }}
                  >
                    Marcar asistencia
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}
