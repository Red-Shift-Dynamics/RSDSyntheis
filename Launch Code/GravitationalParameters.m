%{
====================================================================================================
FUNCTION NAME: GravitationalParameters.m
AUTHOR: Julio César Benavides, Ph.D.
INITIATED: 11/09/2021
REVISED: 12/22/2024
====================================================================================================
FUNCTION DESCRIPTION:
This function returns the respective gravitational parameters for a set of solar system bodies given
a cell that specifies the bodies of interest.
====================================================================================================
INPUT VARIABLES:
(Bodies)|A cell with an "n" number of strings that specify the bodies of interest.
====================================================================================================
OUTPUT VARIABLES:
(Gm)|A vector with the respective gravitational parameters of the specified bodies.
====================================================================================================
VARIABLE FORMAT, DIMENSIONS, AND UNITS:
(Bodies)|Row Cell {1 x n}|[]
----------------------------------------------------------------------------------------------------
(Gm)|Row Vector {1 x n}|[km^3/s^2]
====================================================================================================
USER-DEFINED FUNCTIONS:
None.
====================================================================================================
ABBREVIATIONS:
None.
====================================================================================================
ADDITIONAL COMMENTS:
All gravitational parameter data was updated on December 17, 2024, by Julio César Benavides, Ph.D.,
using the Jet Propulsion laboratory (JPL) Horizons on-line solar system data and ephemeris
computation service.
====================================================================================================
PERMISSION:
Any use of this code, either in part or in full, must first be approved by Dr. Julio César
Benavides, Founder and Curator of the Astronautical Engineering Archives (AEA).  For permission to
use this code, Dr. Benavides may be contacted at aea.engineer.com.
====================================================================================================
%}
function Gm = GravitationalParameters(Bodies)
    
    Sun = 132712440041.93938;
    % [km^3/s^2]Gravitational parameter of the Sun.
    
    Mercury = 22031.86855;
    % [km^3/s^2]Gravitational parameter of Mercury.
    
    Venus = 324858.592;
    % [km^3/s^2]Gravitational parameter of Venus.
    
    Earth = 398600.435436;
    % [km^3/s^2]Gravitational parameter of the Earth.
    
    Moon = 4902.800066;
    % [km^3/s^2]Gravitational parameter of the Moon.
    
    Mars = 42828.375214;
    % [km^3/s^2]Gravitational parameter of Mars.

    Phobos = 0.0007208244;
    % [km^3/s^2]Gravitational parameter of Phobos.

    Deimos = 0.0001201374;
    % [km^3/s^2]Gravitational parameter of Deimos.
    
    Ceres = 62.6284;
    % [km^3/s^2]Gravitational parameter of Ceres.
    
    Vesta = 17.28824;
    % [km^3/s^2]Gravitational parameter of Vesta.
    
    Pallas = 13.63;
    % [km^3/s^2]Gravitational parameter of Pallas.
    
    Hygiea = 7.0;
    % [km^3/s^2]Gravitational parameter of Hygiea.
        
    Jupiter = 126686531.900;
    % [km^3/s^2]Gravitational parameter of Jupiter.

    Ganymede = 9887.8328;
    % [km^3/s^2]Gravitational parameter of Ganymede.

    Callisto = 7179.2834;
    % [km^3/s^2]Gravitational parameter of Callisto.

    Io = 5959.9155;
    % [km^3/s^2]Gravitational parameter of Io.

    Europa = 3202.7121;
    % [km^3/s^2]Gravitational parameter of Europa.
    
    Saturn = 37931206.234;
    % [km^3/s^2]Gravitational parameter of Saturn.

    Titan = 8978.14;
    % [km^3/s^2]Gravitational parameter of Titan.

    Rhea = 153.94;
    % [km^3/s^2]Gravitational parameter of Rhea.

    Iapetus = 120.52;
    % [km^3/s^2]Gravitational parameter of Iapetus.

    Dione = 73.116;
    % [km^3/s^2]Gravitational parameter of Dione.

    Tethys = 41.21;
    % [km^3/s^2]Gravitational parameter of Tethys.

    Enceladus = 7.210367;
    % [km^3/s^2]Gravitational parameter of Enceladus.

    Mimas = 2.503489;
    % [km^3/s^2]Gravitational parameter of Mimas.
    
    Uranus = 5793951.256;
    % [km^3/s^2]Gravitational parameter of Uranus.

    Titania = 235.402561;
    % [km^3/s^2]Gravitational parameter of Titania.

    Oberon = 201.163402;
    % [km^3/s^2]Gravitational parameter of Oberon.

    Umbriel = 78.222796;
    % [km^3/s^2]Gravitational parameter of Umbriel.

    Ariel = 90.303279;
    % [km^3/s^2]Gravitational parameter of Ariel.

    Miranda = 4.3983637;
    % [km^3/s^2]Gravitational parameter of Miranda.
    
    Neptune = 6835099.97;
    % [km^3/s^2]Gravitational parameter of Neptune.

    Triton = 1428.495;
    % [km^3/s^2]Gravitational parameter of Triton.

    Proteus = 2.58;
    % [km^3/s^2]Gravitational parameter of Proteus.
    
    Pluto = 869.326;
    % [km^3/s^2]Gravitational parameter of Pluto.

    Charon = 106.10;
    % [km^3/s^2]Gravitational parameter of Charon.
    
    Satellite = 0;
    % [km^3/s^2]Gravitational parameter of the satellite.
    
    n = numel(Bodies);
    % []Number of bodies that will be used in the analysis.
    
    Gm = zeros(1,n);
    % []Allocates memory for the gravitational parameter vector.
    
    for k = 1:n
        
        switch(Bodies{k})
            
            case('Sun')
                
                Gm(k) = Sun;
                % [km^2/s^2]Gravitational parameter of the Sun.
                
            case('Mercury')
                
                Gm(k) = Mercury;
                % [km^3/s^2]Gravitational parameter of Mercury.
                
            case('Venus')
                
                Gm(k) = Venus;
                % [km^3/s^2]Gravitational parameter of Venus.
                
            case('Earth')
                
                Gm(k) = Earth;
                % [km^3/s^2]Gravitational parameter of the Earth.
                
            case('Moon')
                
                Gm(k) = Moon;
                % [km^3/s^2]Gravitational parameter of the Moon.
                
            case('Mars')
                
                Gm(k) = Mars;
                % [km^3/s^2]Gravitational parameter of Mars.

            case('Phobos')
                
                Gm(k) = Phobos;
                % [km^3/s^2]Gravitational parameter of Phobos.

            case('Deimos')
                
                Gm(k) = Deimos;
                % [km^3/s^2]Gravitational parameter of Deimos.
                
            case('Ceres')
                
                Gm(k) = Ceres;
                % [km^3/s^2]Gravitational parameter of Ceres.
                
            case('Vesta')
                
                Gm(k) = Vesta;
                % [km^3/s^2]Gravitational parameter of Vesta.
                
            case('Pallas')
                
                Gm(k) = Pallas;
                % [km^3/s^2]Gravitational parameter of Pallas.
                
            case('Hygiea')
                
                Gm(k) = Hygiea;
                % [km^3/s^2]Gravitational parameter of Hygiea.
                
            case('Jupiter')
                
                Gm(k) = Jupiter;
                % [km^3/s^2]Gravitational parameter of Jupiter.

            case('Ganymede')
                
                Gm(k) = Ganymede;
                % [km^3/s^2]Gravitational parameter of Ganymede.

            case('Callisto')
                
                Gm(k) = Callisto;
                % [km^3/s^2]Gravitational parameter of Callisto.

            case('Io')
                
                Gm(k) = Io;
                % [km^3/s^2]Gravitational parameter of Io.

            case('Europa')
                
                Gm(k) = Europa;
                % [km^3/s^2]Gravitational parameter of Europa.
                
            case('Saturn')
                
                Gm(k) = Saturn;
                % [km^3/s^2]Gravitational parameter of Saturn.

            case('Titan')
                
                Gm(k) = Titan;
                % [km^3/s^2]Gravitational parameter of Titan.

            case('Rhea')
                
                Gm(k) = Rhea;
                % [km^3/s^2]Gravitational parameter of Rhea.

            case('Iapetus')
                
                Gm(k) = Iapetus;
                % [km^3/s^2]Gravitational parameter of Iapetus.

            case('Dione')
                
                Gm(k) = Dione;
                % [km^3/s^2]Gravitational parameter of Dione.

            case('Tethys')
                
                Gm(k) = Tethys;
                % [km^3/s^2]Gravitational parameter of Tethys.

            case('Enceladus')
                
                Gm(k) = Enceladus;
                % [km^3/s^2]Gravitational parameter of Enceladus.

            case('Mimas')
                
                Gm(k) = Mimas;
                % [km^3/s^2]Gravitational parameter of Mimas.
                
            case('Uranus')
                
                Gm(k) = Uranus;
                % [km^3/s^2]Gravitational parameter of Uranus.

            case('Titania')
                
                Gm(k) = Titania;
                % [km^3/s^2]Gravitational parameter of Titania.

            case('Oberon')
                
                Gm(k) = Oberon;
                % [km^3/s^2]Gravitational parameter of Oberon.

            case('Umbriel')
                
                Gm(k) = Umbriel;
                % [km^3/s^2]Gravitational parameter of Umbriel.

            case('Ariel')
                
                Gm(k) = Ariel;
                % [km^3/s^2]Gravitational parameter of Ariel.

            case('Miranda')
                
                Gm(k) = Miranda;
                % [km^3/s^2]Gravitational parameter of Miranda.

            case('Neptune')
                
                Gm(k) = Neptune;
                % [km^3/s^2]Gravitational parameter of Neptune.

            case('Triton')
                
                Gm(k) = Triton;
                % [km^3/s^2]Gravitational parameter of Triton.

            case('Proteus')
                
                Gm(k) = Proteus;
                % [km^3/s^2]Gravitational parameter of Proteus.
                
            case('Pluto')
                
                Gm(k) = Pluto;
                % [km^3/s^2]Gravitational parameter of Pluto.

            case('Charon')
                
                Gm(k) = Charon;
                % [km^3/s^2]Gravitational parameter of Charon.

            case('Satellite')
                
                Gm(k) = Satellite;
                % [km^3/s^2]Gravitational parameter of the satellite.
                
        end
        
    end
    
end
%===================================================================================================