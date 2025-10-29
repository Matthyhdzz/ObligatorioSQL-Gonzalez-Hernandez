import { salasMock } from "../api/MockData";

// Simula una llamada a la API
export function obtenerSalas() {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(salasMock);
    }, 500); // simula un pequeño retraso de red
  });
}
