class Nave{
	var velocidad = 0
	var direccionDelSol = -10
	var combustible
	
	method velocidad() = velocidad
	method direccionDelSol() = direccionDelSol
	method acelerar(unaVelocidad){
		velocidad = 100000.min(velocidad + unaVelocidad)
	}
	method desacelerar(unaVelocidad){
		velocidad = 0.max(velocidad - unaVelocidad)
	}
	method irHaciaElSol() {direccionDelSol = 10}
	method escaparDelSol() {direccionDelSol = -10}
	method ponerseParaleloAlSol() {direccionDelSol = 0}	
	method acercarseUnPocoAlSol() {
		direccionDelSol = 10.min(direccionDelSol + 1)
	}
	method alejarseUnPocoDelSol(){
		direccionDelSol = -10.max(direccionDelSol - 1)
	}
	method combustible() = combustible
	method cargarCombustible(unaCantidad){
		combustible += unaCantidad
	}
	method descargarCombustible(unaCantidad){
		combustible = 0.max(combustible-unaCantidad)
	}
	method prepararViaje(){
		velocidad += 5000
		self.cargarCombustible(3000)
	}
	method condicionAdicional() = true
	method estaTranquila(){
		return combustible >= 4000 and velocidad <= 12000 and self.condicionAdicional()
	}
	method estaDeRelajo(){ return self.estaTranquila() and self.tienePocaActividad()}
	
}

class NaveBaliza inherits Nave{
	var colorBaliza
	var contador = 0
	method colorBaliza() = colorBaliza
	method cambiarColorDeBaliza(colorNuevo){
		colorBaliza = colorNuevo
		contador ++
	}
	override method prepararViaje(){
		super()
		colorBaliza = "verde"
		self.ponerseParaleloAlSol()
	}
	override method condicionAdicional(){return self.colorBaliza()  != "rojo"}
	method escapar(){self.irHaciaElSol()}
	method avisar(){self.cambiarColorDeBaliza("rojo")}
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	method tienePocaActividad(){
		return contador == 0
	}
}

class NavePasajeros inherits Nave{
	var pasajeros
	var comida = 0
	var bebida = 0
	
	method pasajeros() = pasajeros
	method comida() = comida
	method bebida() = bebida
	method cargarComida(unaCantidad){comida += unaCantidad}
	method cargarBebida(unaCantidad){bebida += unaCantidad}
	method descargarComida(unaCantidad){comida -= unaCantidad}
	method descargarBebida(unaCantidad){bebida -= unaCantidad}
	override method prepararViaje(){
		super()
		comida += 4*pasajeros
		bebida += 6*pasajeros
		self.acercarseUnPocoAlSol()
	}
	method escapar(){velocidad = velocidad*2}
	method avisar(){
		comida -= 1*pasajeros
		bebida -= 2*pasajeros
	}
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	method tienePocaActividad(){}
}

class NaveCombate inherits Nave{
	var estaInvisible = false
	var misilesDesplegados = false
	const mensajes = []
	method estaInvisible() = estaInvisible
	method ponerseVisible(){estaInvisible = false}
	method ponerseInvisible(){estaInvisible = true}
	method misilesDesplegados() = misilesDesplegados
	method desplegarMisiles() {misilesDesplegados = true}
	method replegarMisiles() {misilesDesplegados=false}
	method mensajes() = mensajes
	method emitirMensaje(unMensaje){
		mensajes.add(unMensaje)
		return unMensaje
	}
	method mensajesEmitidos(){return self.mensajes()}
	method primerMensajeEmitido(){return mensajes.first()}
	method ultimoMensajeEmitido(){return mensajes.last()}
	method esEscueta(){
		return mensajes.all({m => m.size()<30})
	}
	method emitioMensaje(unMensaje){
		return mensajes.contains(unMensaje)
	}
	override method prepararViaje(){
		super()
		velocidad += 15000
		self.emitirMensaje("Saliendo en misión")
	}
	override method condicionAdicional(){
		return not self.misilesDesplegados()
	}
	method escapar(){
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	method avisar(){
		self.emitirMensaje("Amenaza recibida")
	}
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	method tienePocaActividad(){
		return self.esEscueta()
	}
}

class NaveHospital inherits NavePasajeros{
	var quirofanoPreparado = false
	method quirofanoPreparado() = quirofanoPreparado
	override method condicionAdicional(){
		return not self.quirofanoPreparado() 
	}
	override method recibirAmenaza(){
		super()
		quirofanoPreparado = true
	}
}

class NaveCombateSi inherits NaveCombate{
	override method condicionAdicional(){
		return not self.estaInvisible()
	}
	override method recibirAmenaza(){
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}

	