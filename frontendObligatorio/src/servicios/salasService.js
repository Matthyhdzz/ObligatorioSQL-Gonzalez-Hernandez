import { salasMock } from "../api/MockData";

// aca lo que hago es simular una llamada a una api para corroborar que todo funciona bien, y luego simulo un tiempo de 500ms de retraso.
export function obtenerSalas() {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(salasMock);
    }, 500); 
  });
}
