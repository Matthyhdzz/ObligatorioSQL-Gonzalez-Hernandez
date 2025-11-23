import { useState, useEffect } from "react";

export default function Reportes() {
  const [salas, setSalas] = useState([]);
  const [turnos, setTurnos] = useState([]);
  const [promedios, setPromedios] = useState([]);
  const [carreras, setCarreras] = useState([]);
  const [ocupacion, setOcupacion] = useState([]);
  const [asistencias, setAsistencias] = useState([]);
  const [sancionesRol, setSancionesRol] = useState([]);
  const [uso, setUso] = useState([]);
  const [topActivos, setTopActivos] = useState([]);
  const [faltas, setFaltas] = useState([]);
  const [programasSanciones, setProgramasSanciones] = useState([]);

  useEffect(() => {
    fetch("http://localhost:5000/reportes/salas-mas-reservadas")
      .then((r) => r.json())
      .then(setSalas);

    fetch("http://localhost:5000/reportes/turnos-mas-demandados")
      .then((r) => r.json())
      .then(setTurnos);

    fetch("http://localhost:5000/reportes/promedio-participantes")
      .then((r) => r.json())
      .then(setPromedios);

    fetch("http://localhost:5000/reportes/reservas-carrera-facultad")
      .then((r) => r.json())
      .then(setCarreras);

    fetch("http://localhost:5000/reportes/ocupacion-edificios")
      .then((r) => r.json())
      .then(setOcupacion);

    fetch("http://localhost:5000/reportes/reservas-asistencias-rol")
      .then((r) => r.json())
      .then(setAsistencias);

    fetch("http://localhost:5000/reportes/sanciones-rol")
      .then((r) => r.json())
      .then(setSancionesRol);

    fetch("http://localhost:5000/reportes/uso-reservas")
      .then((r) => r.json())
      .then(setUso);

    fetch("http://localhost:5000/reportes/top-participantes-activos")
      .then((r) => r.json())
      .then(setTopActivos);

    fetch("http://localhost:5000/reportes/salas-mas-faltas")
      .then((r) => r.json())
      .then(setFaltas);

    fetch("http://localhost:5000/reportes/programas-mas-sanciones")
      .then((r) => r.json())
      .then(setProgramasSanciones);
  }, []);

  const tableStyle = {
    borderCollapse: "collapse",
    marginBottom: "2rem",
  };

  const thStyle = {
    background: "#333",
    color: "white",
  };

  return (
    <div>
      <h2>Reportes del Sistema</h2>

      <h3>1) Salas más reservadas</h3>
      <table border="1" style={tableStyle} cellPadding="8">
        <thead style={thStyle}>
          <tr>
            <th>Sala</th>
            <th>Edificio</th>
            <th>Total Reservas</th>
          </tr>
        </thead>
        <tbody>
          {salas.map((r, i) => (
            <tr key={i}>
              <td>{r.nombre_sala}</td>
              <td>{r.edificio}</td>
              <td>{r.total_reservas}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <h3>2) Turnos más demandados</h3>
      <table border="1" style={tableStyle} cellPadding="8">
        <thead style={thStyle}>
          <tr>
            <th>Inicio</th>
            <th>Fin</th>
            <th>Total Reservas</th>
          </tr>
        </thead>
        <tbody>
          {turnos.map((t, i) => (
            <tr key={i}>
              <td>{t.hora_inicio}</td>
              <td>{t.hora_fin}</td>
              <td>{t.total_reservas}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <h3>3) Promedio de participantes por sala</h3>
      <table border="1" style={tableStyle} cellPadding="8">
        <thead style={thStyle}>
          <tr>
            <th>Sala</th>
            <th>Edificio</th>
            <th>Promedio</th>
          </tr>
        </thead>
        <tbody>
          {promedios.map((p, i) => (
            <tr key={i}>
              <td>{p.nombre_sala}</td>
              <td>{p.edificio}</td>
              <td>{p.promedio_participantes}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <h3>4) Cantidad de reservas por carrera y facultad</h3>
      <table border="1" style={tableStyle} cellPadding="8">
        <thead style={thStyle}>
          <tr>
            <th>Facultad</th>
            <th>Carrera</th>
            <th>Reservas</th>
          </tr>
        </thead>
        <tbody>
          {carreras.map((c, i) => (
            <tr key={i}>
              <td>{c.facultad}</td>
              <td>{c.carrera}</td>
              <td>{c.cantidad_reservas}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <h3>5) Porcentaje de ocupación por edificio</h3>
      <table border="1" style={tableStyle} cellPadding="8">
        <thead style={thStyle}>
          <tr>
            <th>Edificio</th>
            <th>Reservas</th>
            <th>Ocupación (%)</th>
          </tr>
        </thead>
        <tbody>
          {ocupacion.map((o, i) => (
            <tr key={i}>
              <td>{o.edificio}</td>
              <td>{o.reservas_realizadas}</td>
              <td>{o.porcentaje_ocupacion}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <h3>6) Reservas y asistencias por rol</h3>
      <table border="1" style={tableStyle} cellPadding="8">
        <thead style={thStyle}>
          <tr>
            <th>Rol</th>
            <th>Total Reservas</th>
            <th>Asistencias</th>
          </tr>
        </thead>
        <tbody>
          {asistencias.map((a, i) => (
            <tr key={i}>
              <td>{a.rol}</td>
              <td>{a.total_reservas}</td>
              <td>{a.asistencias}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <h3>7) Sanciones por rol</h3>
      <table border="1" style={tableStyle} cellPadding="8">
        <thead style={thStyle}>
          <tr>
            <th>Rol</th>
            <th>Total sanciones</th>
          </tr>
        </thead>
        <tbody>
          {sancionesRol.map((s, i) => (
            <tr key={i}>
              <td>{s.rol}</td>
              <td>{s.total_sanciones}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <h3>8) Porcentaje de uso de reservas</h3>
      <table border="1" style={tableStyle} cellPadding="8">
        <thead style={thStyle}>
          <tr>
            <th>Usadas (%)</th>
            <th>No Usadas (%)</th>
          </tr>
        </thead>
        <tbody>
          {uso.map((u, i) => (
            <tr key={i}>
              <td>{u.porcentaje_usadas}</td>
              <td>{u.porcentaje_no_usadas}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <h3>9.A) Participantes con más reservas activas</h3>
      <table border="1" style={tableStyle} cellPadding="8">
        <thead style={thStyle}>
          <tr>
            <th>CI</th>
            <th>Nombre</th>
            <th>Apellido</th>
            <th>Reservas Activas</th>
          </tr>
        </thead>
        <tbody>
          {topActivos.map((u, i) => (
            <tr key={i}>
              <td>{u.ci}</td>
              <td>{u.nombre}</td>
              <td>{u.apellido}</td>
              <td>{u.reservas_activas}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <h3>9.B) Salas con más faltas</h3>
      <table border="1" style={tableStyle} cellPadding="8">
        <thead style={thStyle}>
          <tr>
            <th>Sala</th>
            <th>Edificio</th>
            <th>Faltas</th>
          </tr>
        </thead>
        <tbody>
          {faltas.map((f, i) => (
            <tr key={i}>
              <td>{f.nombre_sala}</td>
              <td>{f.edificio}</td>
              <td>{f.faltas}</td>
            </tr>
          ))}
        </tbody>
      </table>

      <h3>9.C) Programas académicos con más sanciones</h3>
      <table border="1" style={tableStyle} cellPadding="8">
        <thead style={thStyle}>
          <tr>
            <th>Programa</th>
            <th>Sanciones</th>
          </tr>
        </thead>
        <tbody>
          {programasSanciones.map((p, i) => (
            <tr key={i}>
              <td>{p.nombre_programa}</td>
              <td>{p.sanciones}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
