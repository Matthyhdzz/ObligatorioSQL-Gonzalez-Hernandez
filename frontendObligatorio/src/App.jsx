import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Navbar from "./Components/Navbar";
import Home from "./Paginas/Home";
import Salas from "./Paginas/Salas";
import Participantes from "./Paginas/Participantes";
import Reservas from "./Paginas/Reservas";
import Sanciones from "./Paginas/Sanciones";

export default function App() {
  return (
    <Router>
      <Navbar />
      <div style={{ padding: 20 }}>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/salas" element={<Salas />} />
          <Route path="/participantes" element={<Participantes />} />
          <Route path="/reservas" element={<Reservas />} />
          <Route path="/sanciones" element={<Sanciones />} />
        </Routes>
      </div>
    </Router>
  );
}
