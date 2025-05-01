package com.example.logindemo.util;

import com.example.logindemo.model.IndianState;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.*;

/**
 * Provides comprehensive data for Indian cities.
 */
@Component
@Slf4j
public class IndiaCitiesDataProvider {

    // Map to store cities by state
    private final Map<IndianState, List<String>> citiesByState = new HashMap<>();

    @PostConstruct
    public void init() {
        // Initialize city data
        log.info("Initializing comprehensive India cities data");
        populateCitiesData();
    }

    /**
     * Get all cities for a specific state.
     * 
     * @param state The state to get cities for
     * @return List of city names for the specified state
     */
    public List<String> getCitiesByState(IndianState state) {
        return citiesByState.getOrDefault(state, Collections.emptyList());
    }

    /**
     * Populate the cities data map.
     */
    private void populateCitiesData() {
        // Andhra Pradesh
        addCitiesForState(IndianState.ANDHRA_PRADESH,
                "Visakhapatnam", "Vijayawada", "Guntur", "Nellore", "Kurnool", "Rajahmundry", 
                "Tirupati", "Kakinada", "Kadapa", "Anantapur", "Vizianagaram", "Eluru", 
                "Ongole", "Nandyal", "Machilipatnam", "Adoni", "Tenali", "Proddatur", 
                "Chittoor", "Hindupur", "Srikakulam", "Bhimavaram", "Madanapalle", "Guntakal",
                "Dharmavaram", "Gudivada", "Narasaraopet", "Tadipatri", "Tadepalligudem");

        // Arunachal Pradesh
        addCitiesForState(IndianState.ARUNACHAL_PRADESH,
                "Itanagar", "Naharlagun", "Pasighat", "Namsai", "Tezu", "Bomdila", "Tawang", 
                "Aalo", "Ziro", "Roing", "Khonsa", "Changlang", "Seppa", "Daporijo", "Yingkiong");

        // Assam
        addCitiesForState(IndianState.ASSAM,
                "Guwahati", "Silchar", "Dibrugarh", "Jorhat", "Nagaon", "Tinsukia", "Tezpur", 
                "Karimganj", "Diphu", "Goalpara", "Sivasagar", "Bongaigaon", "North Lakhimpur", 
                "Dhubri", "Mangaldoi", "Hamren", "Nalbari", "Hojai", "Barpeta", "Kokrajhar", 
                "Golaghat", "Duliajan", "Dhemaji", "Biswanath Chariali", "Sonari");

        // Bihar
        addCitiesForState(IndianState.BIHAR,
                "Patna", "Gaya", "Bhagalpur", "Muzaffarpur", "Darbhanga", "Arrah", "Begusarai", 
                "Chhapra", "Katihar", "Purnia", "Munger", "Saharsa", "Bettiah", "Samastipur", 
                "Hajipur", "Dehri", "Siwan", "Motihari", "Nawada", "Bagaha", "Buxar", "Kishanganj", 
                "Aurangabad", "Jehanabad", "Madhubani", "Sasaram", "Sitamarhi", "Araria", "Lakhisarai");

        // Chhattisgarh
        addCitiesForState(IndianState.CHHATTISGARH,
                "Raipur", "Bhilai", "Bilaspur", "Korba", "Durg", "Raigarh", "Rajnandgaon", 
                "Jagdalpur", "Ambikapur", "Chirmiri", "Dhamtari", "Mahasamund", "Kirandul", 
                "Bhatapara", "Dongargarh", "Janjgir", "Naila Janjgir", "Bemetara", "Tilda Newra");

        // Goa
        addCitiesForState(IndianState.GOA,
                "Panaji", "Margao", "Vasco da Gama", "Mapusa", "Ponda", "Bicholim", "Curchorem", 
                "Sanquelim", "Canacona", "Quepem", "Cuncolim", "Valpoi", "Pernem", "Sanguem", "Marcela");

        // Gujarat
        addCitiesForState(IndianState.GUJARAT,
                "Ahmedabad", "Surat", "Vadodara", "Rajkot", "Bhavnagar", "Jamnagar", "Junagadh", 
                "Gandhinagar", "Gandhidham", "Anand", "Navsari", "Morbi", "Nadiad", "Surendranagar", 
                "Bharuch", "Mehsana", "Bhuj", "Porbandar", "Palanpur", "Valsad", "Vapi", "Gondal", 
                "Veraval", "Godhra", "Patan", "Dahod", "Botad", "Amreli", "Jetpur", "Palitana");

        // Haryana
        addCitiesForState(IndianState.HARYANA,
                "Faridabad", "Gurgaon", "Panipat", "Ambala", "Yamunanagar", "Rohtak", "Hisar", 
                "Karnal", "Sonipat", "Panchkula", "Bhiwani", "Sirsa", "Bahadurgarh", "Jind", 
                "Thanesar", "Kaithal", "Rewari", "Palwal", "Hansi", "Narnaul", "Fatehabad", 
                "Gohana", "Tohana", "Charkhi Dadri", "Narwana", "Shahbad", "Mandi Dabwali", "Pehowa");

        // Himachal Pradesh
        addCitiesForState(IndianState.HIMACHAL_PRADESH,
                "Shimla", "Dharamshala", "Solan", "Mandi", "Palampur", "Baddi", "Nahan", "Kullu", 
                "Chamba", "Hamirpur", "Una", "Bilaspur", "Sundarnagar", "Yol", "Nalagarh", "Kangra", 
                "Santokhgarh", "Parwanoo", "Manali", "Tanda", "Mehatpur Basdehra", "Shamshi");
                
        // Add more states with their cities...
        // Jharkhand
        addCitiesForState(IndianState.JHARKHAND,
                "Ranchi", "Jamshedpur", "Dhanbad", "Bokaro", "Hazaribagh", "Deoghar", "Giridih",
                "Ramgarh", "Phusro", "Medininagar", "Chirkunda", "Gumla", "Dumka", "Chakradharpur",
                "Chatra", "Godda", "Lohardaga", "Pakur", "Sahibganj", "Simdega");
                
        // Karnataka
        addCitiesForState(IndianState.KARNATAKA,
                "Bangalore", "Mysore", "Hubli", "Mangalore", "Belgaum", "Gulbarga", "Davanagere",
                "Bellary", "Bijapur", "Shimoga", "Tumkur", "Raichur", "Hassan", "Udupi", "Bidar",
                "Hospet", "Gadag", "Kolar", "Mandya", "Bagalkot", "Haveri", "Chitradurga",
                "Chikmagalur", "Gangavati", "Bhadravati", "Chamarajanagar", "Karwar", "Chikballapur");
                
        // Kerala
        addCitiesForState(IndianState.KERALA,
                "Thiruvananthapuram", "Kochi", "Kozhikode", "Thrissur", "Kollam", "Kannur",
                "Alappuzha", "Kottayam", "Palakkad", "Malappuram", "Kasaragod", "Pathanamthitta",
                "Idukki", "Wayanad", "Nedumangad", "Neyyattinkara", "Kalamassery", "Alwaye",
                "Kunnamkulam", "Ottapalam", "Thodupuzha", "Kayamkulam", "Payyannur", "Ponnani");
                
        // Madhya Pradesh
        addCitiesForState(IndianState.MADHYA_PRADESH,
                "Indore", "Bhopal", "Jabalpur", "Gwalior", "Ujjain", "Sagar", "Dewas", "Satna",
                "Ratlam", "Rewa", "Burhanpur", "Khandwa", "Bhind", "Chhindwara", "Guna", "Morena",
                "Mandsaur", "Vidisha", "Damoh", "Hoshangabad", "Neemuch", "Singrauli", "Betul",
                "Seoni", "Datia", "Nagda", "Pithampur", "Gadarwara", "Shahdol");
                
        // Maharashtra
        addCitiesForState(IndianState.MAHARASHTRA,
                "Mumbai", "Pune", "Nagpur", "Thane", "Nashik", "Aurangabad", "Solapur", "Kolhapur", 
                "Amravati", "Nanded", "Akola", "Jalgaon", "Latur", "Dhule", "Ahmednagar", "Chandrapur",
                "Parbhani", "Bhusawal", "Jalna", "Satara", "Yavatmal", "Ulhasnagar", "Wardha",
                "Washim", "Hinganghat", "Gondia", "Bhandara", "Parli", "Gadchiroli");
                
        // Manipur
        addCitiesForState(IndianState.MANIPUR,
                "Imphal", "Thoubal", "Bishnupur", "Churachandpur", "Kakching", "Ukhrul", "Senapati",
                "Chandel", "Tamenglong", "Jiribam", "Moreh", "Lilong", "Nambol", "Kangpokpi", "Moirang");
                
        // Meghalaya
        addCitiesForState(IndianState.MEGHALAYA,
                "Shillong", "Tura", "Jowai", "Nongpoh", "Williamnagar", "Baghmara", "Resubelpara",
                "Khliehriat", "Nongstoin", "Mawkyrwat", "Cherrapunji", "Mairang", "Mankachar", "Phulbari");
                
        // Mizoram
        addCitiesForState(IndianState.MIZORAM,
                "Aizawl", "Lunglei", "Champhai", "Saiha", "Kolasib", "Serchhip", "Lawngtlai",
                "Mamit", "Khawzawl", "Hnahthial", "Saitual", "Zawlnuam");
                
        // Nagaland
        addCitiesForState(IndianState.NAGALAND,
                "Kohima", "Dimapur", "Mokokchung", "Tuensang", "Wokha", "Zunheboto", "Mon",
                "Phek", "Kiphire", "Longleng", "Peren", "Pfutsero", "Chümoukedima");
                
        // Odisha
        addCitiesForState(IndianState.ODISHA,
                "Bhubaneswar", "Cuttack", "Rourkela", "Berhampur", "Sambalpur", "Puri", "Balasore",
                "Bhadrak", "Baripada", "Jharsuguda", "Jeypore", "Angul", "Bargarh", "Bhawanipatna",
                "Balangir", "Rayagada", "Dhenkanal", "Paradip", "Kendujhar", "Jajpur", "Sundargarh",
                "Koraput", "Boudh", "Nabarangpur", "Phulbani", "Malkangiri", "Nuapada", "Sonepur");
                
        // Punjab
        addCitiesForState(IndianState.PUNJAB,
                "Ludhiana", "Amritsar", "Jalandhar", "Patiala", "Bathinda", "Mohali", "Pathankot",
                "Hoshiarpur", "Batala", "Moga", "Firozpur", "Khanna", "Muktsar", "Fazilka", "Gurdaspur",
                "Faridkot", "Abohar", "Malerkotla", "Sangrur", "Barnala", "Rajpura", "Phagwara",
                "Sunam", "Nangal", "Kapurthala", "Mansa", "Nawanshahr", "Nakodar", "Ropar");
                
        // Rajasthan
        addCitiesForState(IndianState.RAJASTHAN,
                "Jaipur", "Jodhpur", "Kota", "Bikaner", "Ajmer", "Udaipur", "Bhilwara", "Alwar",
                "Sikar", "Sri Ganganagar", "Pali", "Bharatpur", "Hanumangarh", "Beawar", "Tonk",
                "Kishangarh", "Nagaur", "Banswara", "Bundi", "Jhunjhunu", "Churu", "Sawai Madhopur",
                "Jaisalmer", "Baran", "Sirohi", "Jhalawar", "Dholpur", "Barmer", "Chittorgarh");
                
        // Sikkim
        addCitiesForState(IndianState.SIKKIM,
                "Gangtok", "Namchi", "Mangan", "Gyalshing", "Rangpo", "Singtam", "Jorethang",
                "Nayabazar", "Ravangla", "Soreng", "Yuksom", "Geyzing", "Pakyong", "Rongli");
                
        // Tamil Nadu
        addCitiesForState(IndianState.TAMIL_NADU,
                "Chennai", "Coimbatore", "Madurai", "Tiruchirappalli", "Salem", "Tirunelveli",
                "Tiruppur", "Vellore", "Erode", "Thoothukudi", "Dindigul", "Thanjavur", "Ranipet",
                "Karur", "Nagercoil", "Kanchipuram", "Hosur", "Neyveli", "Cuddalore", "Kumbakonam",
                "Tiruvannamalai", "Pollachi", "Rajapalayam", "Pudukkottai", "Vaniyambadi", "Ambur",
                "Nagapattinam", "Karaikkudi", "Sivakasi", "Theni", "Perambalur", "Dharmapuri");
                
        // Telangana
        addCitiesForState(IndianState.TELANGANA,
                "Hyderabad", "Warangal", "Nizamabad", "Karimnagar", "Khammam", "Ramagundam",
                "Mahbubnagar", "Nalgonda", "Adilabad", "Suryapet", "Siddipet", "Miryalaguda",
                "Jagtial", "Bodhan", "Kothagudem", "Wanaparthy", "Mancherial", "Sangareddy",
                "Mahabubabad", "Vikarabad", "Tandur", "Medak", "Kamareddy", "Husnabad", "Jangaon");
                
        // Tripura
        addCitiesForState(IndianState.TRIPURA,
                "Agartala", "Udaipur", "Dharmanagar", "Kailashahar", "Belonia", "Khowai", "Ambassa",
                "Santirbazar", "Kamalpur", "Bishalgarh", "Teliamura", "Melaghar", "Sabroom", "Amarpur");
                
        // Uttar Pradesh
        addCitiesForState(IndianState.UTTAR_PRADESH,
                "Lucknow", "Kanpur", "Ghaziabad", "Agra", "Meerut", "Varanasi", "Prayagraj", "Bareilly",
                "Aligarh", "Moradabad", "Saharanpur", "Gorakhpur", "Noida", "Firozabad", "Jhansi",
                "Muzaffarnagar", "Mathura", "Budaun", "Rampur", "Shahjahanpur", "Farrukhabad",
                "Ayodhya", "Bulandshahr", "Hapur", "Etawah", "Mirzapur", "Bahraich", "Banda",
                "Lakhimpur Kheri", "Hathras", "Fatehpur", "Barabanki", "Akbarpur", "Hardoi");
                
        // Uttarakhand
        addCitiesForState(IndianState.UTTARAKHAND,
                "Dehradun", "Haridwar", "Roorkee", "Haldwani", "Rudrapur", "Kashipur", "Rishikesh",
                "Pithoragarh", "Ramnagar", "Khatima", "Nainital", "Almora", "Kotdwar", "Bageshwar",
                "Champawat", "Jaspur", "Pauri", "Tehri", "Uttarkashi", "Gopeshwar", "Manglaur");
                
        // West Bengal
        addCitiesForState(IndianState.WEST_BENGAL,
                "Kolkata", "Asansol", "Siliguri", "Durgapur", "Bardhaman", "Malda", "Baharampur",
                "Habra", "Jalpaiguri", "Kharagpur", "Haldia", "Krishnanagar", "Darjeeling", "Alipurduar",
                "Purulia", "Bankura", "Cooch Behar", "Midnapore", "Balurghat", "Krishnapur", "Raiganj",
                "Ranaghat", "Suri", "Bolpur", "Jangipur", "Khardaha", "Basirhat", "Baruipur", "Contai");
                
        // Andaman and Nicobar Islands
        addCitiesForState(IndianState.ANDAMAN_AND_NICOBAR_ISLANDS,
                "Port Blair", "Bambooflat", "Garacharma", "Prothrapur", "Rangat", "Mayabunder",
                "Diglipur", "Hutbay", "Car Nicobar", "Campbell Bay", "Kamorta", "Malacca", "Wimberlygunj");
                
        // Chandigarh
        addCitiesForState(IndianState.CHANDIGARH,
                "Chandigarh", "Manimajra", "Burail", "Dhanas", "Daria", "Hallomajra", "Kaimbwala",
                "Khuda Alisher", "Maloya", "Raipur Khurd", "Behlana", "Kishangarh", "Raipur Kalan");
                
        // Dadra and Nagar Haveli and Daman and Diu
        addCitiesForState(IndianState.DADRA_AND_NAGAR_HAVELI_AND_DAMAN_AND_DIU,
                "Silvassa", "Daman", "Diu", "Varkund", "Amli", "Naroli", "Samarvarni", "Dadra",
                "Moti Daman", "Nani Daman", "Dunetha", "Kachigam", "Vapi", "Bhimpore", "Khanvel");
                
        // Delhi
        addCitiesForState(IndianState.DELHI,
                "New Delhi", "Delhi", "Rohini", "Pitampura", "Dwarka", "Janakpuri", "Vasant Kunj",
                "Mayur Vihar", "Saket", "Laxmi Nagar", "Karol Bagh", "Chandni Chowk", "Connaught Place",
                "Greater Kailash", "Shahdara", "Dilshad Garden", "Hauz Khas", "Rajouri Garden",
                "Model Town", "Narela", "Najafgarh", "Uttam Nagar", "Punjabi Bagh", "Shalimar Bagh");
                
        // Jammu and Kashmir
        addCitiesForState(IndianState.JAMMU_AND_KASHMIR,
                "Srinagar", "Jammu", "Anantnag", "Baramulla", "Kupwara", "Pulwama", "Udhampur",
                "Kathua", "Budgam", "Sopore", "Poonch", "Rajouri", "Handwara", "Bandipore", "Ganderbal",
                "Bhaderwah", "Kulgam", "Shopian", "Doda", "Reasi", "Samba", "Kishtwar", "Kargil");
                
        // Ladakh
        addCitiesForState(IndianState.LADAKH,
                "Leh", "Kargil", "Diskit", "Zanskar", "Nubra", "Padum", "Khalsi", "Drass",
                "Nyoma", "Shyok", "Chuchot", "Saspol", "Wakha", "Khaltse", "Skurbuchan");
                
        // Lakshadweep
        addCitiesForState(IndianState.LAKSHADWEEP,
                "Kavaratti", "Agatti", "Amini", "Andrott", "Kalpeni", "Kiltan", "Chetlat",
                "Kadmat", "Bitra", "Minicoy", "Bangaram", "Suheli", "Tinnakara");
                
        // Puducherry
        addCitiesForState(IndianState.PUDUCHERRY,
                "Puducherry", "Karaikal", "Yanam", "Mahe", "Villianur", "Ozhukarai", "Ariyankuppam",
                "Bahour", "Nedungadu", "Thirunallar", "Kottucherry", "Karikalambakkam", "Mannadipet");
    }

    /**
     * Helper method to add cities for a state.
     * 
     * @param state  The state
     * @param cities Variable arguments list of cities
     */
    private void addCitiesForState(IndianState state, String... cities) {
        List<String> cityList = new ArrayList<>(Arrays.asList(cities));
        // Sort alphabetically
        Collections.sort(cityList);
        citiesByState.put(state, cityList);
        log.debug("Added {} cities for state {}", cities.length, state.getDisplayName());
    }
} 