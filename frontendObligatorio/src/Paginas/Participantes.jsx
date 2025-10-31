import { useEffect, useState } from "react";
import { obtenerParticipantes } from "../servicios/participantesService";

export default function Participantes() {
  const [participantes, setParticipantes] = useState([]);

  useEffect(() => {
    obtenerParticipantes().then((data) => setParticipantes(data));
  }, []);

  return (
    <div>
      <h2>Gestión de Participantes</h2>

      {participantes.length === 0 ? (
        <p>Cargando Participantes...</p>
      ) : (
        <table
          border="1"
          cellPadding="8"
          style={{ borderCollapse: "collapse", marginTop: "1rem" }}
        >
          <thead>
            <tr>
              <th>Apellido</th>
              <th>Ci</th>
              <th>correo</th>
              <th>nombre</th>
            </tr>
          </thead>
          <tbody>
            {participantes.map((participante) => (
              <tr key={`${participante.ci}`}>
                <td>{participante.apellido}</td>
                <td>{participante.ci}</td>
                <td>{participante.nombre}</td>
                <td>{participante.correo}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}
