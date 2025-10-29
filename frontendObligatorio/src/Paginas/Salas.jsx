import { useEffect, useState } from "react";
import { obtenerSalas } from "../servicios/salasService";

export default function Salas() {
  const [salas, setSalas] = useState([]);

  useEffect(() => {
    obtenerSalas().then((data) => setSalas(data));
  }, []);

  return (
    <div>
      <h2>Gestión de Salas</h2>

      {salas.length === 0 ? (
        <p>Cargando salas...</p>
      ) : (
        <table border="1" cellPadding="8" style={{ borderCollapse: "collapse", marginTop: "1rem" }}>
          <thead>
            <tr>
              <th>ID</th>
              <th>Nombre</th>
              <th>Edificio</th>
              <th>Capacidad</th>
              <th>Tipo</th>
            </tr>
          </thead>
          <tbody>
            {salas.map((sala) => (
              <tr key={sala.id}>
                <td>{sala.id}</td>
                <td>{sala.nombre}</td>
                <td>{sala.edificio}</td>
                <td>{sala.capacidad}</td>
                <td>{sala.tipo}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}
