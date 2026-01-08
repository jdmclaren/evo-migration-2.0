# evo_migration

Migration model with evolutionary algorithm, written in MATLAB

This is an extension of the first version (used in McLaren et al Movement Ecol, 2023), found in https://github.com/jdmclaren/evo-migration

Simulates migration of naive (first-time) migrating birds according to inherited migratorz headings, which can be both inherited 
and directed relative to either a geogrphic, magnetic or sun compass "axis". Another option is to  
follow geomagnetic signposts to switch between inherited headings en route, using mean field (IGRF) geomagnetic data between 1900-2024.
The evolutionary strategy algorithm implemented simaultes inheritance of headings and signposts as averages, 
including intrinsic (stochastic) variability.

This version includes synthetic modelled winds, which switch stochastically but follow the general trade vs. Westerly pattern globally.

Also in this version, hi-res coastal and vegetation data are incorporated.

These are first applied to Long-tailed cuckoo migration (Koekoa), using script "run_evo_gene_phene_LTC.m".

Another change is the incorporation of separate heading-related alleles; for the cuckoo migration study, however, 
we considered headings as a trait controlled by many genes, so use the option "Inf" in the menu when running the model, 
indicating effectively infinite numbersof controlling alleles.

In order to run the model and plotting routines, the following MATAB toolboxes are required:

	Mapping toolbox
	Statistics and Machine Learning Toolbox
	Parallel Computing Toolbox

	Chad Greene's Climate Data Toolbox, which requires downloading
	https://www.chadagreene.com/CDT/CDT_Contents.html

Additionally, the model uses already-included data and scripts from 

	(i) the IGRF https://www.ngdc.noaa.gov/IAGA/vmod/igrf.html, 
	as implemented by https://www.mathworks.com/matlabcentral/fileexchange/34388-international-geomagnetic-reference-field-igrf-model,
	found in the geo_data folder
	(ii) Consensus landcover https://www.earthenv.org/landcover, downscaled to 1x1 degrees (also found in the folder geo_data)
	(iii) a package to sample von Mises random variables vmrand(fMu, fKappa, varargin)
	https://de.mathworks.com/matlabcentral/fileexchange/37241-vmrand-fmu-fkappa-varargin
	(iv) Phillipp Berens' Circular statistics package 
	https://www.mathworks.com/matlabcentral/fileexchange/10676-circular-statistics-toolbox-directional-statistics
	(v) a Brewer colormap toolbox https://de.mathworks.com/matlabcentral/fileexchange/45208-colorbrewer-attractive-and-distinctive-colormaps

For more info, email james.mclaren@uni-oldenburg.de


