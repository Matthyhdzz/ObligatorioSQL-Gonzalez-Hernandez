import { useEffect, useState } from "react";
import { obtenerReservas } from "../servicios/reservasService";

export default function Reservas() {
  const [reservas, setReservas] = useState([]);

  useEffect(() => {
    obtenerReservas().then((data) => setReservas(data));
  }, []);

  return (
    <div>
      <h2>Gestión de Reservas</h2>

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
              <th>Id de reserva</th>
              <th>nombre de la sala</th>
              <th>edificio</th>
              <th>fecha</th>
              <th>Id del turno</th>
              <th>estado</th>
            </tr>
          </thead>
          <tbody>
            {reservas.map((reserva) => (
              <tr key={`${reserva.id_reserva}`}>
                <td>{reserva.nombre_sala}</td>
                <td>{reserva.edificio}</td>
                <td>{reserva.fecha}</td>
                <td>{reserva.id_turno}</td>
                 <td>{reserva.estado}</td>

              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}
