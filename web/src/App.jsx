import { useState, useEffect } from 'react'

function App() {
  const [gastos, setGastos] = useState([])

  useEffect(() => {
    // Pide los datos al Backend (puerto 8080)
    fetch('http://localhost:8080/api/gastos')
      .then(response => response.json())
      .then(data => setGastos(data))
      .catch(error => console.error("Error cargando gastos:", error))
  }, [])

  return (
    <div style={{ padding: '20px', fontFamily: 'Arial' }}>
      <h1>💸 Mis Gastos (FinTrack)</h1>
      
      <ul>
        {gastos.map((gasto) => (
          <li key={gasto.id} style={{ marginBottom: '10px' }}>
            <strong>{gasto.concepto}</strong>: {gasto.cantidad}€ 
            <span style={{ color: 'gray', marginLeft: '10px' }}>
              ({gasto.categoria})
            </span>
          </li>
        ))}
      </ul>

      {gastos.length === 0 && <p>Cargando gastos... (O no hay datos)</p>}
    </div>
  )
}

export default App