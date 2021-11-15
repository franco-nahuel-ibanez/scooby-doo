
import wollok.game.*
import direcciones.*
import niveles.*

object scooby {
	
	var property position = game.at(5,5) 
	var property energia = 30
	var property salud = 100
	
	var property direccion = arriba

	method image() = "scooby2.png"
	
	method aumentarEnergia(cantidad){ energia += cantidad }
	
	method perderSalud() { salud -= 10 }  
	
	method aumentarSalud(cantidad){ salud += cantidad }
	
	method reiniciar(){ 
		energia = 30
		salud = 100
	}
	
	method interactuarCon(unElemento) {
		unElemento.interactuar()
    }
    
      
	method verificarPerder(){
		if (energia <= 0 or salud <= 0) { nivel1.perder() }
	}
	
	method elementosAlRededor(nivel){
	//debemos preguntar al nivel si hay un elemento en una posicion
		nivel.hayElementosAlRededorDe([
			self.siguienteIzquierda(),
			self.siguienteDerecha(),
			self.siguienteArriba(),
			self.siguienteAbajo()
		])
	}
	//MOVIMIENTOS
	method siguienteIzquierda() = game.at(self.position().x() - 1, self.position().y())
	method siguienteDerecha() = game.at(self.position().x() + 1, self.position().y())	
	method siguienteArriba() = game.at(self.position().x(), self.position().y() + 1)	
	method siguienteAbajo() = game.at(self.position().x(), self.position().y() - 1)
	
	
	method retrocede() {
		position = direccion.opuesto().siguiente(position)
		energia += 1
	}
	
	method retrocedeCon(amigos) {
		self.retrocede()
		amigos.movete(direccion.opuesto())
	}

	method irArriba() {
		direccion = arriba
		self.avanzar()
	}

	method irAbajo() {
		direccion = abajo
		self.avanzar()
	}

	method irIzquierda() {
		direccion = izquierda
		self.avanzar()
	}

	method irDerecha() {
		direccion = derecha
		self.avanzar()
	}
	
	method avanzar() {
		position = direccion.siguiente(position)
		energia -= 1
		self.verificarPerder()
		
	}
	
	method setDireccion(unaDireccion) {
		direccion = unaDireccion
	}
	
	
}