import { useState, useEffect } from 'react'

function App() {
  const [gastos, setGastos] = useState([])
  
  // Variables para el formulario
  const [concepto, setConcepto] = useState("")
  const [cantidad, setCantidad] = useState("")

  // 1. Cargar gastos al iniciar
  useEffect(() => {
    fetch('http://localhost:8080/api/gastos')
      .then(response => response.json())
      .then(data => setGastos(data))
  }, [])

  // 2. Función para enviar el formulario
  const handleSubmit = (e) => {
    e.preventDefault() // Evita que la página se recargue

    const nuevoGasto = {
      concepto: concepto,
      cantidad: parseFloat(cantidad),
      fecha: new Date().toISOString().split('T')[0], // Fecha de hoy automática
      categoria: "Varios" // Categoría fija por ahora
    }

    // Enviamos a Spring Boot
    fetch('http://localhost:8080/api/gastos', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(nuevoGasto)
    })
    .then(response => response.json())
    .then(data => {
      // Agregamos el nuevo gasto a la lista visual sin recargar
      setGastos([...gastos, data])
      // Limpiamos el formulario
      setConcepto("")
      setCantidad("")
    })
  }

  return (
    <div style={{ padding: '20px', fontFamily: 'Arial', maxWidth: '600px', margin: '0 auto' }}>
      <h1>FinTrack Web</h1>

      {/* FORMULARIO */}
      <div style={{ background: '#f0f0f0', padding: '15px', borderRadius: '8px', marginBottom: '20px' }}>
        <h3 style={{color: '#000000ff'}}>Añadir Nuevo Gasto</h3>
        <form onSubmit={handleSubmit} style={{ display: 'flex', gap: '10px' }}>
          <input 
            type="text" 
            placeholder="Concepto (ej: Café)" 
            value={concepto}
            onChange={(e) => setConcepto(e.target.value)}
            required
            style={{ padding: '8px', flex: 1 }}
          />
          <input 
            type="number" 
            placeholder="Cantidad" 
            value={cantidad}
            onChange={(e) => setCantidad(e.target.value)}
            required
            style={{ padding: '8px', width: '80px' }}
          />
          <button type="submit" style={{ padding: '8px 15px', background: '#007bff', color: 'white', border: 'none', borderRadius: '4px', cursor: 'pointer' }}>
            Guardar
          </button>
        </form>
      </div>

      {/* LISTA DE GASTOS */}
      <ul style={{ listStyle: 'none', padding: 0 }}>
        {gastos.map((gasto) => (
          <li key={gasto.id} style={{ borderBottom: '1px solid #ddd', padding: '10px 0', display: 'flex', justifyContent: 'space-between' }}>
            <span>
              <strong>{gasto.concepto}</strong> <small style={{color:'gray'}}>({gasto.fecha})</small>
            </span>
            <span style={{ fontWeight: 'bold', color: '#d9534f' }}>
              -{gasto.cantidad}€
            </span>
          </li>
        ))}
      </ul>
    </div>
  )
}

export default App