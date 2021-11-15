import wollok.game.*
import utilidades.*
import niveles.*
import scooby.*


class Elementos{
	
	var property position
	
	method image()
	
	method otorga()
	
	method realizarAccion(nivel, elemento){ 
		nivel.borrarObjeto(self)
	}
	
	method validarLugarLibre(direccion) {
		const posAlLado = direccion.siguiente(position) 
		const lugarLibre = game.getObjectsIn(posAlLado)
			.all{ obj => obj.puedePisarte(self) } 
		
		if (!lugarLibre) 
			throw new Exception(message = "Algo lo traba.")
	}
	method interactuar(){ scooby.retrocede()}
	
	method esEnemigo() = false
	 
	method puedePisarte(_) = false

}


//alimentos, botiquin y moneda

class Galleta inherits Elementos{
	
	override method otorga() = 10
	override method image() = "burger.png"
	
	override method realizarAccion(nivel,elemento){
		
		elemento.aumentarEnergia(self.otorga())
		super(nivel,elemento)
	}
}

class Hamburguesa inherits Elementos{
	
	override method otorga() = 20
	override method image() = "galleta.png"
	
	override method realizarAccion(nivel,elemento){
		
		elemento.aumentarEnergia(self.otorga())
		super(nivel,elemento)
	}
}

class Botiquin inherits Elementos {
	
	override method otorga() = 10
	override method image() = "botiquin.png"
	
	override method realizarAccion(nivel,elemento){
		
		elemento.aumentarSalud(self.otorga())
		super(nivel,elemento)
	}
}

class Curita inherits Elementos {	
	override method otorga() = 5
	override method image() = "curitas.png"
	
	override method realizarAccion(nivel,elemento){
		
		elemento.aumentarSalud(self.otorga())
		super(nivel,elemento)
	}
}

class Moneda inherits Elementos {
	
	override method otorga() = 10
	override method image() = "dinero.png"
	
	override method realizarAccion(nivel,elemento){}
	
	override method interactuar() { 
		nivel2.agregarDinero(self.otorga())
		nivel2.borrarObjeto(self)
		scooby.perderSalud()
	}
}
//cofres sorpresa
class CofreSorpresa{
	var property position
	var property fueActivada = false
	var property image = "sorpresa.png"
	
	method cambiarImagen(){image="sorpresaUsada.png"}
	
	method realizarAccion(nivel,elemento){
        if (not  fueActivada ) { 
            self.cambiarImagen()
            fueActivada = true 
            self.sorpresa(elemento)
        }
    }

    method sorpresa(elemento)
    
    method esEnemigo() = false
	
	method puedePisarte(_) = false
	
	method interactuar(){scooby.retrocede()}
}

class CofreSorpresa1 inherits CofreSorpresa{
	
	override method sorpresa(elemento){
        elemento.aumentarEnergia( -15 )
    }
}

class CofreSorpresa2 inherits CofreSorpresa{
	
	override method sorpresa(elemento){
        elemento.aumentarEnergia( 30 )
    }
}

class CofreSorpresa3 inherits CofreSorpresa{
	
	override method sorpresa(elemento){
        nivel1.ponerElementos(1, hamburguesa)
    }
}

class CofreSorpresa4 inherits CofreSorpresa{
	
	override method sorpresa(elemento){
        elemento.position(utilidades.posicionRandom())
    }
}
class Amigos {
	
	var property position
	var imagen 
	
	
	method image () = imagen
	
	method interactuar() {
		if (self.puedeSerMovido(scooby.direccion())){
			position = scooby.direccion().siguiente(position)
			self.dentroDeposito()
		}
		else {
			game.say(self, "Algo lo traba.")
			scooby.retrocede()
		}
			
	}

	method puedeSerMovido(direccion) {
		const posAlLado = direccion.siguiente(position) 
		const lugarLibre = game.getObjectsIn(posAlLado)
			.all{ obj => obj.puedePisarte(self) } 
		
		return lugarLibre
		
	}
	
	method dentroDeposito() {
		if (self.estoyEnDeposito()){
			nivel1.borrarObjeto(self)
			nivel1.agregarAmigo()
		}
	}
	method esEnemigo() = false
	
	method puedePisarte(_) = false

	method realizarAccion(nivel, elemento) = game.say(self, "Llevame a la camioneta! Scooby!")
	
	method estoyEnDeposito() = position == deposito.position()
}


class Fantasma {
	
	var property position
	
	method image() = "fantasma.png"
	method buscar(){position = utilidades.posicionRandom()}
	
	method esEnemigo() = true
	
	method realizarAccion(elemento) = game.say(self , "Buuuuuuuuuu")
	
	method interactuar() { 
		scooby.perderSalud()
		scooby.retrocede()
	}
	
	method puedePisarte(_) = false
}

object deposito {
	var property position = utilidades.posicionRandom()
	method image () = "maquina_del_misterio.png"
	method puedePisarte(_) = true
	method interactuar(){scooby.retrocede()}
	method realizarAccion(elemento) = game.say(self, "Traea a tus amigos, scooby!!!") 
}

object fondo{
	var property imagen = "fondo2.jpg"
	method image() = imagen 
	
	method cambiarFondo(nuevaImagen) { 
		imagen = nuevaImagen
	}
}
object salida{
	var property position = utilidades.posicionRandom()
	
	method image () = "maquina_del_misterio.png"
	
	method interactuar(){nivel2.ganar()}
}


object marcadorEnergia{
	method position() =  game.at(2, 8)
	method text() = "Energia: " + scooby.energia()   
}

object marcadorSalud{
	method position() =  game.at(4, 8)
	method text() = "Salud: " + scooby.salud()   	
}

object marcadorPistas{
	method position() =  game.at(6, 8)
	method text() = "Amigos: " + nivel1.amigos()  
}

object marcadorDinero{
	method position() =  game.at(6, 8)
	method text() = "Dinero: " + nivel2.dinero() 
}