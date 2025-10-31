import { useEffect, useState } from "react";
import { obtenerSanciones } from "../servicios/sancionesService";

export default function Sanciones() {
  const [sanciones, setSanciones] = useState([]);

  useEffect(() => {
    obtenerSanciones().then((data) => setSanciones(data));
  }, []);

  return (
    <div>
      <h2>Gestión de Sanciones</h2>

      {sanciones.length === 0 ? (
        <p>Cargando Sanciones...</p>
      ) : (
        <table
          border="1"
          cellPadding="8"
          style={{ borderCollapse: "collapse", marginTop: "1rem" }}
        >
          <thead>
            <tr>
              <th>Id sancion</th>
              <th>Ci participante</th>
              <th>fecha de inicio</th>
              <th>fecha de fin</th>
            </tr>
          </thead>
          <tbody>
            {sanciones.map((sancion_participante) => (
              <tr key={`${sancion_participante.id_sancion}`}>
                <td>{sancion_participante.id_sancion}</td>
                <td>{sancion_participante.ci_participante}</td>
                <td>{sancion_participante.fecha_inicio}</td>
                <td>{sancion_participante.fecha_fin}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}
