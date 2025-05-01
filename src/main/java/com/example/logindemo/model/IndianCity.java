package com.example.logindemo.model;

public enum IndianCity implements IndianCityInterface {
    // Andhra Pradesh
    VISAKHAPATNAM("Visakhapatnam", IndianState.ANDHRA_PRADESH),
    VIJAYAWADA("Vijayawada", IndianState.ANDHRA_PRADESH),
    GUNTUR("Guntur", IndianState.ANDHRA_PRADESH),
    NELLORE("Nellore", IndianState.ANDHRA_PRADESH),
    KURNOOL("Kurnool", IndianState.ANDHRA_PRADESH),
    
    // Arunachal Pradesh
    ITANAGAR("Itanagar", IndianState.ARUNACHAL_PRADESH),
    NAHARLAGUN("Naharlagun", IndianState.ARUNACHAL_PRADESH),
    PASIGHAT("Pasighat", IndianState.ARUNACHAL_PRADESH),
    TAWANG("Tawang", IndianState.ARUNACHAL_PRADESH),
    
    // Assam
    GUWAHATI("Guwahati", IndianState.ASSAM),
    SILCHAR("Silchar", IndianState.ASSAM),
    DIBRUGARH("Dibrugarh", IndianState.ASSAM),
    JORHAT("Jorhat", IndianState.ASSAM),
    NAGAON("Nagaon", IndianState.ASSAM),
    
    // Bihar
    PATNA("Patna", IndianState.BIHAR),
    GAYA("Gaya", IndianState.BIHAR),
    BHAGALPUR("Bhagalpur", IndianState.BIHAR),
    MUZAFFARPUR("Muzaffarpur", IndianState.BIHAR),
    DARBHANGA("Darbhanga", IndianState.BIHAR),
    
    // Chhattisgarh
    RAIPUR("Raipur", IndianState.CHHATTISGARH),
    BHILAI("Bhilai", IndianState.CHHATTISGARH),
    BILASPUR("Bilaspur", IndianState.CHHATTISGARH),
    KORBA("Korba", IndianState.CHHATTISGARH),
    
    // Goa
    PANAJI("Panaji", IndianState.GOA),
    MARGAO("Margao", IndianState.GOA),
    VASCO_DA_GAMA("Vasco da Gama", IndianState.GOA),
    MAPUSA("Mapusa", IndianState.GOA),
    
    // Gujarat
    AHMEDABAD("Ahmedabad", IndianState.GUJARAT),
    SURAT("Surat", IndianState.GUJARAT),
    VADODARA("Vadodara", IndianState.GUJARAT),
    RAJKOT("Rajkot", IndianState.GUJARAT),
    GANDHINAGAR("Gandhinagar", IndianState.GUJARAT),
    
    // Haryana
    FARIDABAD("Faridabad", IndianState.HARYANA),
    GURGAON("Gurgaon", IndianState.HARYANA),
    PANIPAT("Panipat", IndianState.HARYANA),
    AMBALA("Ambala", IndianState.HARYANA),
    KARNAL("Karnal", IndianState.HARYANA),
    
    // Himachal Pradesh
    SHIMLA("Shimla", IndianState.HIMACHAL_PRADESH),
    DHARAMSHALA("Dharamshala", IndianState.HIMACHAL_PRADESH),
    SOLAN("Solan", IndianState.HIMACHAL_PRADESH),
    MANDI("Mandi", IndianState.HIMACHAL_PRADESH),
    
    // Jharkhand
    RANCHI("Ranchi", IndianState.JHARKHAND),
    JAMSHEDPUR("Jamshedpur", IndianState.JHARKHAND),
    DHANBAD("Dhanbad", IndianState.JHARKHAND),
    BOKARO("Bokaro", IndianState.JHARKHAND),
    
    // Karnataka
    BANGALORE("Bangalore", IndianState.KARNATAKA),
    MYSORE("Mysore", IndianState.KARNATAKA),
    HUBLI("Hubli", IndianState.KARNATAKA),
    MANGALORE("Mangalore", IndianState.KARNATAKA),
    
    // Kerala
    THIRUVANANTHAPURAM("Thiruvananthapuram", IndianState.KERALA),
    KOCHI("Kochi", IndianState.KERALA),
    KOZHIKODE("Kozhikode", IndianState.KERALA),
    THRISSUR("Thrissur", IndianState.KERALA),
    
    // Madhya Pradesh
    INDORE("Indore", IndianState.MADHYA_PRADESH),
    BHOPAL("Bhopal", IndianState.MADHYA_PRADESH),
    JABALPUR("Jabalpur", IndianState.MADHYA_PRADESH),
    GWALIOR("Gwalior", IndianState.MADHYA_PRADESH),
    
    // Maharashtra
    MUMBAI("Mumbai", IndianState.MAHARASHTRA),
    PUNE("Pune", IndianState.MAHARASHTRA),
    NAGPUR("Nagpur", IndianState.MAHARASHTRA),
    THANE("Thane", IndianState.MAHARASHTRA),
    NASHIK("Nashik", IndianState.MAHARASHTRA),
    
    // Other major cities from remaining states
    IMPHAL("Imphal", IndianState.MANIPUR),
    SHILLONG("Shillong", IndianState.MEGHALAYA),
    AIZAWL("Aizawl", IndianState.MIZORAM),
    KOHIMA("Kohima", IndianState.NAGALAND),
    BHUBANESWAR("Bhubaneswar", IndianState.ODISHA),
    LUDHIANA("Ludhiana", IndianState.PUNJAB),
    AMRITSAR("Amritsar", IndianState.PUNJAB),
    JAIPUR("Jaipur", IndianState.RAJASTHAN),
    JODHPUR("Jodhpur", IndianState.RAJASTHAN),
    GANGTOK("Gangtok", IndianState.SIKKIM),
    CHENNAI("Chennai", IndianState.TAMIL_NADU),
    COIMBATORE("Coimbatore", IndianState.TAMIL_NADU),
    HYDERABAD("Hyderabad", IndianState.TELANGANA),
    WARANGAL("Warangal", IndianState.TELANGANA),
    AGARTALA("Agartala", IndianState.TRIPURA),
    LUCKNOW("Lucknow", IndianState.UTTAR_PRADESH),
    KANPUR("Kanpur", IndianState.UTTAR_PRADESH),
    VARANASI("Varanasi", IndianState.UTTAR_PRADESH),
    DEHRADUN("Dehradun", IndianState.UTTARAKHAND),
    KOLKATA("Kolkata", IndianState.WEST_BENGAL),
    PORT_BLAIR("Port Blair", IndianState.ANDAMAN_AND_NICOBAR_ISLANDS),
    CHANDIGARH_CITY("Chandigarh", IndianState.CHANDIGARH),
    SILVASSA("Silvassa", IndianState.DADRA_AND_NAGAR_HAVELI_AND_DAMAN_AND_DIU),
    NEW_DELHI("New Delhi", IndianState.DELHI),
    SRINAGAR("Srinagar", IndianState.JAMMU_AND_KASHMIR),
    JAMMU("Jammu", IndianState.JAMMU_AND_KASHMIR),
    LEH("Leh", IndianState.LADAKH),
    KAVARATTI("Kavaratti", IndianState.LAKSHADWEEP),
    PUDUCHERRY_CITY("Puducherry", IndianState.PUDUCHERRY);

    private final String displayName;
    private final IndianState state;

    IndianCity(String displayName, IndianState state) {
        this.displayName = displayName;
        this.state = state;
    }

    public String getDisplayName() {
        return displayName;
    }

    public IndianState getState() {
        return state;
    }

    @Override
    public String toString() {
        return displayName;
    }
} 