asm DispositivoSicurezza

import StandardLibrary
signature:
	//Domains
	enum domain Dispositivo = {TELECAMERA | ALLARME | SENSORE}
	enum domain SceltaAS = {ACCENDERE | SPEGNERE}
	enum domain Stato = {ACCESO | SPENTO}

	//rappresenter? gli id (da 1 a 3) per ogni tipo di dispositivo
	domain IdDomain subsetof Integer
	
	//Functions
	//mi restituisce per ogni combinazione dispositivo-id se ? acceso o spento
	controlled acceso: Prod(Dispositivo, IdDomain) -> Stato
	//mi restituira informazioni sul dispositvo

	//diverse funzioni per le scelte che deve compiere l'utente
	monitored scelta: SceltaAS
	monitored sceltaDispositivo: Dispositivo
	monitored sceltaID: IdDomain

	//variabile in cui assegno il titolo del dispositivo
	out info: String
	//messaggio di errore
	out messaggio: String
	
definitions:
	domain IdDomain = {0:2}

	rule r_info($disp in Dispositivo, $id in IdDomain)= 
		switch($disp, $id)
			case(TELECAMERA, 0): info := "Telecamera 0"
			case(TELECAMERA, 1): info := "Telecamera 1"
			case(TELECAMERA, 2): info := "Telecamera 2"
			case(SENSORE, 0): info := "Sensore 0"
			case(SENSORE, 1): info := "Sensore 1"
			case(SENSORE, 2): info := "Sensore 2"
			case(ALLARME, 0): info := "Allarme 0"
			case(ALLARME, 1): info := "Allarme 1"
			case(ALLARME, 2): info := "Allarme 2"
		endswitch   
		
	 rule r_spegni($disp in Dispositivo, $id in IdDomain) = 
		if(acceso($disp,$id) = ACCESO) then
		par
			 acceso($disp,$id) := SPENTO
			 r_info[$disp,$id]
			 messaggio := "Dispositivo spento correttamente!"
		endpar
		else
			messaggio := "Errore, dispositivo gia' spento!"
		endif
		
	 rule r_accendi($disp in Dispositivo, $id in IdDomain) = 
		if(acceso($disp,$id) = SPENTO) then
		par
			 acceso($disp,$id) := ACCESO
			 r_info[$disp,$id]
			 messaggio := "Dispositivo acceso correttamente!"
		endpar
		else
			messaggio := "Errore, dispositivo gia' acceso!"
		endif
	
	 main rule r_Main = 
		switch(scelta)
			case ACCENDERE: r_accendi[sceltaDispositivo,sceltaID]
			case SPEGNERE: r_spegni[sceltaDispositivo,sceltaID]
		endswitch
			
default init s0:
	function acceso ($disp in Dispositivo, $id in IdDomain) = SPENTO