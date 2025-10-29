import { Link } from "react-router-dom";

export default function Navbar() {
  const navStyle = {
    display: "flex",
    gap: "1rem",
    background: "#20232a",
    padding: "1rem",
  };
  const linkStyle = {
    color: "white",
    textDecoration: "none",
    fontWeight: "bold",
  };

  return (
    <nav style={navStyle}>
      <Link to="/" style={linkStyle}>Inicio</Link>
      <Link to="/salas" style={linkStyle}>Salas</Link>
      <Link to="/participantes" style={linkStyle}>Participantes</Link>
      <Link to="/reservas" style={linkStyle}>Reservas</Link>
      <Link to="/sanciones" style={linkStyle}>Sanciones</Link>
    </nav>
  );
}
