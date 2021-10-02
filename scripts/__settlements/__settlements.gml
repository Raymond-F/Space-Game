// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

// Industry enums. These give goods and services to the settlement's trade portfolio.
enum industry {
	mining,
	refining,
	icecutting,
	hardware,
	agriculture,
	research,
	military,
	luxury
}

// Initializes settlement-related variables at map generation. Loc is a locatin struct.
function settlement_has_industry(loc, ind) {
	return (array_find(loc.industries, ind) >= 0);
}

// Retrieve the relevant sprite to an industry
function settlement_get_industry_icon(ind) {
	switch (ind) {
		case industry.mining: return s_icon_industry_mining;
		case industry.refining: return s_icon_industry_refining;
		case industry.icecutting: return s_icon_industry_icecutting;
		case industry.hardware: return s_icon_industry_hardware;
		case industry.agriculture: return s_icon_industry_agriculture;
		case industry.research: return s_icon_industry_research;
		case industry.military: return s_icon_industry_military;
		case industry.luxury: return s_icon_industry_luxury;
	}
	return s_icon_industry_mining;
}

// Choose a settlement's industries based on its size and security
function settlement_choose_industries(loc) {
	var num_industries_small = [1, 2], num_industries_med = [2,3], num_industries_large = [2, 4];
	var num_industries;
	switch (loc.size) {
		case location_size.small :
			num_industries = irandom_range(num_industries_small[0], num_industries_small[1]);
			break;
		case location_size.medium :
			num_industries = irandom_range(num_industries_med[0], num_industries_med[1]);
			break;
		case location_size.large :
			num_industries = irandom_range(num_industries_large[0], num_industries_large[1]);
			break;
		default :
			num_industries = 2; break;
	}
	var miningc, refiningc, icecuttingc, hardwarec, agric, researchc, militaryc, luxuryc;
	switch (loc.size) {
		case location_size.small :
			miningc = 4; refiningc = 2; icecuttingc = 4; hardwarec = 1;
			agric = 2; researchc = 2; militaryc = 2; luxuryc = 0;
			break;
		case location_size.medium:
			miningc = 2; refiningc = 4; icecuttingc = 1; hardwarec = 3;
			agric = 3; researchc = 1; militaryc = 2; luxuryc = 2;
			break;
		case location_size.large :
			miningc = 1; refiningc = 3; icecuttingc = 1; hardwarec = 5;
			agric = 1; researchc = 1; militaryc = 3; luxuryc = 3;
			break;
		default: miningc = 1; refiningc = 1; icecuttingc = 1; hardwarec = 1;
				 agric = 1; researchc = 1; militaryc = 1; luxuryc = 1;
				 break;
	}
	// Adjust for security. Higher security favors consumer industries more.
	switch (loc.zone_id.security) {
		case zone_security.high: hardwarec *= 1.5; refiningc *= 1.5; militaryc *= 0.7; icecuttingc *= 0.5; miningc *= 0.5;
								 break;
		case zone_security.moderate: hardwarec *= 1.2; refiningc *= 1.2; icecuttingc *= 0.75; miningc *= 0.75;
									 break;
		case zone_security.sparse: luxuryc *= 0.55;
								   break;
		case zone_security.little: hardwarec *= 0.75; refiningc *= 0.9; researchc *= 1.25; luxuryc *= 0.4; militaryc *= 1.25;
								   break;
		case zone_security.lawless: hardwarec *= 0.5; refiningc *= 0.7; researchc *= 1.5; luxuryc *= 0.2;
									militaryc *= 1.5; miningc *= 1.5; icecuttingc *= 1.5;
									break;
		default: break;
	}
	repeat (num_industries) {
		var ind;
		do {
			ind = choose_weighted(industry.mining, miningc, industry.refining, refiningc, industry.icecutting, icecuttingc,
								  industry.hardware, hardwarec, industry.agriculture, agric, industry.research, researchc,
								  industry.military, militaryc, industry.luxury, luxuryc);
		} until (!settlement_has_industry(loc, ind));
		array_push(loc.industries, ind);
	}
}

// Select which shops a settlement has
function settlement_choose_shops(loc) {
	array_push(loc.shops, new shop(shop_type.general, loc));
	array_push(loc.shops, new shop(shop_type.module, loc));
	if (settlement_has_industry(loc, industry.hardware) || settlement_has_industry(loc, industry.military)) {
		array_push(loc.shops, new shop(shop_type.weapon, loc));
	}
	if (loc.size != location_size.small && settlement_has_industry(loc, industry.hardware) ||
		settlement_has_industry(loc, industry.military) || settlement_has_industry(loc, industry.research)) {
	  array_push(loc.shops, new shop(shop_type.ship, loc));
	}
}

function settlement_init(loc) {
	loc.industries = [];
	loc.shops = [];
	// First, choose what industries a settlement has.
	settlement_choose_industries(loc);
	// Now, choose shops and stock those shops.
	settlement_choose_shops(loc);
	for (var i = 0; i < array_length(loc.shops); i++) {
		shop_restock(loc.shops[i]);
	}
}

// Opens the settlement window for a location object
function open_settlement_window(loc){
	var win = instance_create(0, 0, o_settlement_pane);
	win.loc = loc;
	win.title = loc.struct.name;
}