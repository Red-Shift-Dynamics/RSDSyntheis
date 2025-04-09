%{
====================================================================================================
FUNCTION NAME: PlanetaryRadii.m
AUTHOR: Julio César Benavides, Ph.D.
INITIATED: 12/17/2024
REVISED: 12/22/2024
====================================================================================================
FUNCTION DESCRIPTION:
This function returns the respective planetary radii for a set of solar system bodies given a cell
that specifies the bodies of interest.
====================================================================================================
INPUT VARIABLES:
(Bodies)|A cell with an "n" number of strings that specify the bodies of interest.
====================================================================================================
OUTPUT VARIABLES:
(R)|A vector with the respective planetary radii of the specified bodies.
====================================================================================================
VARIABLE FORMAT, DIMENSIONS, AND UNITS:
(Bodies)|Row Cell {1 x n}|[]
----------------------------------------------------------------------------------------------------
(R)|Row Vector {1 x n}|[km]
====================================================================================================
USER-DEFINED FUNCTIONS:
None.
====================================================================================================
ABBREVIATIONS:
None.
====================================================================================================
ADDITIONAL COMMENTS:
All planetary radii data was updated on December 17, 2024, by Julio César Benavides, Ph.D., using
the Jet Propulsion laboratory (JPL) Horizons on-line solar system data and ephemeris computation
service.
====================================================================================================
PERMISSION:
Any use of this code, either in part or in full, must first be approved by Dr. Julio César
Benavides, Founder and Curator of the Astronautical Engineering Archives (AEA).  For permission to
use this code, Dr. Benavides may be contacted at aea.engineer.com.
====================================================================================================
%}
function R = PlanetaryRadii(Bodies)
    
    Sun = 696500.000;
    % [km]Mean equatorial radius of the Sun.
    
    Mercury = 2440.530;
    % [km]Mean equatorial radius of Mercury.
    
    Venus = 6051.893;
    % [km]Mean equatorial radius of Venus.
    
    Earth = 6378.137;
    % [km]Mean equatorial radius of the Earth.
    
    Moon = 1738.000;
    % [km]Mean equatorial radius of the Moon.
    
    Mars = 3396.190;
    % [km]Mean equatorial radius of Mars.

    Phobos = 13.100;
    % [km]Mean equatorial radius of Phobos.

    Deimos = 7.800;
    % [km]Mean equatorial radius of Deimos.
    
    Ceres = 966.200;
    % [km]Mean equatorial radius of Ceres.
    
    Vesta = 572.600;
    % [km]Mean equatorial radius of Vesta.
    
    Pallas = 568.000;
    % [km]Mean equatorial radius of Pallas.
    
    Hygiea = 450.000;
    % [km]Mean equatorial radius of Hygiea.
        
    Jupiter = 71492.000;
    % [km]Mean equatorial radius of Jupiter.

    Ganymede = 2631.200;
    % [km]Mean equatorial radius of Ganymede.

    Callisto = 2410.300;
    % [km]Mean equatorial radius of Callisto.

    Io = 1821.49;
    % [km]Mean equatorial radius of Io.

    Europa = 1560.8;
    % [km]Mean equatorial radius of Europa.
    
    Saturn = 60268.000;
    % [km]Mean equatorial radius of Saturn.

    Titan = 2575.500;
    % [km]Mean equatorial radius of Titan.

    Rhea = 764.5;
    % [km]Mean equatorial radius of Rhea.

    Iapetus = 734.500;
    % [km]Mean equatorial radius of Iapetus.

    Dione = 562.500;
    % [km]Mean equatorial radius of Dione.

    Tethys = 536.300;
    % [km]Mean equatorial radius of Tethys.

    Enceladus = 252.300;
    % [km]Mean equatorial radius of Enceladus.

    Mimas = 198.8;
    % [km]Mean equatorial radius of Mimas.
    
    Uranus = 25559.000;
    % [km]Mean equatorial radius of Uranus.

    Titania = 788.900;
    % [km]Mean equatorial radius of Titania.

    Oberon = 761.400;
    % [km]Mean equatorial radius of Oberon.

    Umbriel = 584.700;
    % [km]Mean equatorial radius of Umbriel.

    Ariel = 581.100;
    % [km]Mean equatorial radius of Ariel.

    Miranda = 240.000;
    % [km]Mean equatorial radius of Miranda.
    
    Neptune = 24766.000;
    % [km]Mean equatorial radius of Neptune.

    Triton = 1352.600;
    % [km]Mean equatorial radius of Triton.

    Proteus = 208.000;
    % [km]Mean equatorial radius of Proteus.
    
    Pluto = 1188.300;
    % [km]Mean equatorial radius of Pluto.

    Charon = 606.000;
    % [km]Mean equatorial radius of Charon.
    
    Satellite = 0;
    % [km]Mean equatorial radius of the satellite.
    
    n = numel(Bodies);
    % []Number of bodies that will be used in the analysis.
    
    R = zeros(1,n);
    % []Allocates memory for the gravitational parameter vector.
    
    for k = 1:n
        
        switch(Bodies{k})
            
            case('Sun')
                
                R(k) = Sun;
                % [km^2/s^2]Gravitational parameter of the Sun.
                
            case('Mercury')
                
                R(k) = Mercury;
                % [km]Mean equatorial radius of Mercury.
                
            case('Venus')
                
                R(k) = Venus;
                % [km]Mean equatorial radius of Venus.
                
            case('Earth')
                
                R(k) = Earth;
                % [km]Mean equatorial radius of the Earth.
                
            case('Moon')
                
                R(k) = Moon;
                % [km]Mean equatorial radius of the Moon.
                
            case('Mars')
                
                R(k) = Mars;
                % [km]Mean equatorial radius of Mars.

            case('Phobos')
                
                R(k) = Phobos;
                % [km]Mean equatorial radius of Phobos.

            case('Deimos')
                
                R(k) = Deimos;
                % [km]Mean equatorial radius of Deimos.
                
            case('Ceres')
                
                R(k) = Ceres;
                % [km]Mean equatorial radius of Ceres.
                
            case('Vesta')
                
                R(k) = Vesta;
                % [km]Mean equatorial radius of Vesta.
                
            case('Pallas')
                
                R(k) = Pallas;
                % [km]Mean equatorial radius of Pallas.
                
            case('Hygiea')
                
                R(k) = Hygiea;
                % [km]Mean equatorial radius of Hygiea.
                
            case('Jupiter')
                
                R(k) = Jupiter;
                % [km]Mean equatorial radius of Jupiter.

            case('Ganymede')
                
                R(k) = Ganymede;
                % [km]Mean equatorial radius of Ganymede.

            case('Callisto')
                
                R(k) = Callisto;
                % [km]Mean equatorial radius of Callisto.

            case('Io')
                
                R(k) = Io;
                % [km]Mean equatorial radius of Io.

            case('Europa')
                
                R(k) = Europa;
                % [km]Mean equatorial radius of Europa.
                
            case('Saturn')
                
                R(k) = Saturn;
                % [km]Mean equatorial radius of Saturn.

            case('Titan')
                
                R(k) = Titan;
                % [km]Mean equatorial radius of Titan.

            case('Rhea')
                
                R(k) = Rhea;
                % [km]Mean equatorial radius of Rhea.

            case('Iapetus')
                
                R(k) = Iapetus;
                % [km]Mean equatorial radius of Iapetus.

            case('Dione')
                
                R(k) = Dione;
                % [km]Mean equatorial radius of Dione.

            case('Tethys')
                
                R(k) = Tethys;
                % [km]Mean equatorial radius of Tethys.

            case('Enceladus')
                
                R(k) = Enceladus;
                % [km]Mean equatorial radius of Enceladus.

            case('Mimas')
                
                R(k) = Mimas;
                % [km]Mean equatorial radius of Mimas.
                
            case('Uranus')
                
                R(k) = Uranus;
                % [km]Mean equatorial radius of Uranus.

            case('Titania')
                
                R(k) = Titania;
                % [km]Mean equatorial radius of Titania.

            case('Oberon')
                
                R(k) = Oberon;
                % [km]Mean equatorial radius of Oberon.

            case('Umbriel')
                
                R(k) = Umbriel;
                % [km]Mean equatorial radius of Umbriel.

            case('Ariel')
                
                R(k) = Ariel;
                % [km]Mean equatorial radius of Ariel.

            case('Miranda')
                
                R(k) = Miranda;
                % [km]Mean equatorial radius of Miranda.

            case('Neptune')
                
                R(k) = Neptune;
                % [km]Mean equatorial radius of Neptune.

            case('Triton')
                
                R(k) = Triton;
                % [km]Mean equatorial radius of Triton.

            case('Proteus')
                
                R(k) = Proteus;
                % [km]Mean equatorial radius of Proteus.
                
            case('Pluto')
                
                R(k) = Pluto;
                % [km]Mean equatorial radius of Pluto.

            case('Charon')
                
                R(k) = Charon;
                % [km]Mean equatorial radius of Charon.

            case('Satellite')
                
                R(k) = Satellite;
                % [km]Mean equatorial radius of the satellite.
                
        end
        
    end
    
end
%===================================================================================================