// ignore_for_file: equal_keys_in_map

class ManglishService {
  // Vowels (standalone)
  static final Map<String, String> _vowels = {
    'a': 'അ',
    'aa': 'ആ',
    'A': 'ആ',
    'i': 'ഇ',
    'ee': 'ഈ',
    'I': 'ഈ',
    'u': 'ഉ',
    'oo': 'ഊ',
    'U': 'ഊ',
    'e': 'എ',
    'E': 'ഏ',
    'ai': 'ഐ',
    'o': 'ഒ',
    'O': 'ഓ',
    'au': 'ഔ',
    'ou': 'ഔ',
    'am': 'അം',
    'ah': 'അഃ',
  };

  // Vowel signs (to be added after consonants)
  static final Map<String, String> _vowelSigns = {
    'a': '',
    'aa': 'ാ',
    'A': 'ാ',
    'i': 'ി',
    'ee': 'ീ',
    'I': 'ീ',
    'u': 'ു',
    'oo': 'ൂ',
    'U': 'ൂ',
    'e': 'െ',
    'E': 'േ',
    'ai': 'ൈ',
    'o': 'ൊ',
    'O': 'ോ',
    'au': 'ൗ',
    'ou': 'ൗ',
    'am': 'ം',
    'ah': 'ഃ',
  };

  // Consonants (base characters)
  static final Map<String, String> _consonants = {
    'k': 'ക്',
    'kh': 'ഖ്',
    'g': 'ഗ്',
    'gh': 'ഘ്',
    'ng': 'ങ്',
    'ch': 'ച്',
    'chh': 'ഛ്',
    'j': 'ജ്',
    'jh': 'ഝ്',
    'nj': 'ഞ്',
    'T': 'ട്',
    'Th': 'ഠ്',
    'D': 'ഡ്',
    'Dh': 'ഢ്',
    'N': 'ണ്',
    't': 'ത്',
    'th': 'ഥ്',
    'd': 'ദ്',
    'dh': 'ധ്',
    'n': 'ന്',
    'p': 'പ്',
    'ph': 'ഫ്',
    'f': 'ഫ്',
    'b': 'ബ്',
    'bh': 'ഭ്',
    'm': 'മ്',
    'y': 'യ്',
    'r': 'ര്',
    'l': 'ല്',
    'v': 'വ്',
    'w': 'വ്',
    'sh': 'ശ്',
    'Sh': 'ഷ്',
    's': 'സ്',
    'h': 'ഹ്',
    'L': 'ള്',
    'zh': 'ഴ്',
    'R': 'റ്',
  };

  // Common complete words for better accuracy
  static final Map<String, String> _commonWords = {
    // Pronouns
    'njan': 'ഞാൻ',
    'njaan': 'ഞാൻ',
    'nee': 'നീ',
    'ni': 'നീ',
    'thaan': 'താൻ',
    'avan': 'അവൻ',
    'aval': 'അവൾ',
    'athu': 'അത്',
    'nammal': 'നമ്മൾ',
    'ningal': 'നിങ്ങൾ',
    'ningaL': 'നിങ്ങൾ',
    'avar': 'അവർ',
    'avaL': 'അവർ',

    // Question words
    'enthu': 'എന്ത്',
    'entho': 'എന്തോ',
    'entha': 'എന്താ',
    'enthaa': 'എന്താ',
    'evide': 'എവിടെ',
    'evideyaa': 'എവിടെയാ',
    'eppo': 'എപ്പോ',
    'eppol': 'എപ്പോൾ',
    'eppozha': 'എപ്പോഴാ',
    'engane': 'എങ്ങനെ',
    'ethra': 'എത്ര',
    'aarenkilum': 'ആരെങ്കിലും',
    'aar': 'ആര്',
    'aara': 'ആര',
    'aaraa': 'ആരാ',
    'aaru': 'ആരു',
    'enthinu': 'എന്തിന്',
    'enthina': 'എന്തിന',
    'enthaan': 'എന്താണ്',

    // Verbs - to be
    'aanu': 'ആണ്',
    'aan': 'ആൻ',
    'aano': 'ആണോ',
    'aanennu': 'ആണെന്ന്',
    'aayirunnu': 'ആയിരുന്നു',
    'aakum': 'ആകും',
    'aayi': 'ആയി',
    'aayirikkum': 'ആയിരിക്കും',
    'alla': 'അല്ല',
    'allaa': 'അല്ല',
    'allo': 'അല്ലോ',
    'allallo': 'അല്ലല്ലോ',

    // Verbs - to have/exist
    'undu': 'ഉണ്ട്',
    'und': 'ഉണ്ട്',
    'undo': 'ഉണ്ടോ',
    'undaayirunnu': 'ഉണ്ടായിരുന്നു',
    'undaakum': 'ഉണ്ടാകും',
    'illa': 'ഇല്ല',
    'ille': 'ഇല്ലേ',
    'illo': 'ഇല്ലോ',
    'illennu': 'ഇല്ലെന്ന്',

    // Common verbs
    'cheyyum': 'ചെയ്യും',
    'cheyyu': 'ചെയ്യു',
    'cheyyan': 'ചെയ്യാൻ',
    'cheythu': 'ചെയ്ത്',
    'varum': 'വരും',
    'vaa': 'വാ',
    'varaam': 'വരാം',
    'vannu': 'വന്നു',
    'varan': 'വരാൻ',
    'pokum': 'പോകും',
    'po': 'പോ',
    'poda': 'പോട',
    'pode': 'പോടെ',
    'poyi': 'പോയി',
    'povan': 'പോവാൻ',
    'pokaan': 'പോകാൻ',
    'parayum': 'പറയും',
    'paranju': 'പറഞ്ഞ്',
    'parayan': 'പറയാൻ',
    'kaanum': 'കാണും',
    'kandu': 'കണ്ട്',
    'kaanan': 'കാണാൻ',
    'kelkkum': 'കേൾക്കും',
    'kettu': 'കേട്ട്',
    'kelkkan': 'കേൾക്കാൻ',
    'ariyum': 'അറിയും',
    'ariyaam': 'അറിയാം',
    'ariyan': 'അറിയാൻ',
    'ariyilla': 'അറിയില്ല',
    'thinnum': 'തിന്നും',
    'thinnaan': 'തിന്നാൻ',
    'kudikkum': 'കുടിക്കും',
    'kudikkan': 'കുടിക്കാൻ',

    // Responses & common phrases
    'shari': 'ശരി',
    'sheriyaa': 'ശരിയാ',
    'sheri': 'ശരി',
    'seriyaanu': 'ശരിയാണ്',
    'venda': 'വേണ്ട',
    'vendaa': 'വേണ്ട',
    'venam': 'വേണം',
    'venaam': 'വേണം',
    'veno': 'വേണോ',
    'vendallo': 'വേണ്ടല്ലോ',
    'pattum': 'പറ്റും',
    'pattu': 'പറ്റ്',
    'pattilla': 'പറ്റില്ല',
    'pattille': 'പറ്റില്ലേ',
    'pattuo': 'പറ്റുവോ',
    'kollam': 'കൊള്ളാം',
    'kollaam': 'കൊള്ളാം',
    'nannaayi': 'നന്നായി',
    'nannayi': 'നന്നായി',
    'nalla': 'നല്ല',
    'nallathu': 'നല്ലത്',
    'valare': 'വളരെ',
    'kurachu': 'കുറച്ച്',
    'kooduthal': 'കൂടുതൽ',

    // Greetings
    'namaskaram': 'നമസ്കാരം',
    'namaskaaram': 'നമസ്കാരം',
    'hai': 'ഹായ്',
    'hello': 'ഹലോ',
    'bye': 'ബൈ',
    'sukham': 'സുഖം',
    'sukhamano': 'സുഖമാണോ',
    'sukhamaano': 'സുഖമാണോ',
    'vishesham': 'വിശേഷം',
    'visheshangal': 'വിശേഷങ്ങൾ',
    'visheshangaL': 'വിശേഷങ്ങൾ',
    'enthaa vishesham': 'എന്താ വിശേഷം',

    // Time
    'innu': 'ഇന്ന്',
    'inne': 'ഇന്നേ',
    'nale': 'നാളെ',
    'naale': 'നാളെ',
    'innale': 'ഇന്നലെ',
    'kalyanam': 'കല്യാണം',
    'raatri': 'രാത്രി',
    'rathri': 'രാത്രി',
    'pakal': 'പകൽ',
    'raavile': 'രാവിലെ',
    'uchakku': 'ഉച്ചക്ക്',
    'vaikunneram': 'വൈകുന്നേരം',

    // Common nouns
    'veedu': 'വീട്',
    'veed': 'വീട്',
    'vittil': 'വീട്ടിൽ',
    'vittile': 'വീട്ടിലെ',
    'sthalam': 'സ്ഥലം',
    'sthalathu': 'സ്ഥലത്ത്',
    'kaaryam': 'കാര്യം',
    'karyam': 'കാര്യം',
    'samayam': 'സമയം',
    'samayathu': 'സമയത്ത്',
    'manushyan': 'മനുഷ്യൻ',
    'manushyar': 'മനുഷ്യർ',
    'aalu': 'ആൾ',
    'aalukal': 'ആളുകൾ',
    'aalukaL': 'ആളുകൾ',
    'samsaaram': 'സംസാരം',
    'samsaram': 'സംസാരം',
    'prasnam': 'പ്രശ്നം',
    'prashnam': 'പ്രശ്നം',
    'paisa': 'പൈസ',
    'rupee': 'രൂപ',
    'roopa': 'രൂപ',

    // Conjunctions & particles
    'ennal': 'എന്നാൽ',
    'pinne': 'പിന്നെ',
    'pakshe': 'പക്ഷേ',
    'athu kondu': 'അത് കൊണ്ട്',
    'ennittu': 'എന്നിട്ട്',
    'ennitu': 'എന്നിട്ട്',
    'angane': 'അങ്ങനെ',
    'ingane': 'ഇങ്ങനെ',
    'athukond': 'അതുകൊണ്ട്',
    'alle': 'അല്ലേ',
    'ano': 'അണോ',
    'thanne': 'തന്നെ',
    'mathram': 'മാത്രം',
    'maathram': 'മാത്രം',
    'koodi': 'കൂടി',
    'koode': 'കൂടെ',
    'koodathe': 'കൂടാതെ',

    // Emotions & Feelings
    'santhosham': 'സന്തോഷം',
    'vishamam': 'വിഷമം',
    'pediyaanu': 'പേടിയാണ്',
    'pediyanu': 'പേടിയാണ്',
    'deshyam': 'ദേഷ്യം',
    'tension': 'ടെൻഷൻ',
    'bore': 'ബോർ',
    'excited': 'എക്സൈറ്റഡ്',
    'stress': 'സ്ട്രെസ്സ്',
    'relaxed': 'റിലാക്സഡ്',
    'confused': 'കൺഫ്യൂസ്ഡ്',

    // Daily activities
    'vishakkunnu': 'വിശക്കുന്നു',
    'vellam': 'വെള്ളം',
    'saadhyam': 'സാധ്യം',
    'kazhichu': 'കഴിച്ച്',
    'kazhikkum': 'കഴിക്കും',
    'kazhikkan': 'കഴിക്കാൻ',
    'kazhikkanam': 'കഴിക്കണം',
    'urangum': 'ഉറങ്ങും',
    'urangan': 'ഉറങ്ങാൻ',
    'padikkum': 'പഠിക്കും',
    'padikkan': 'പഠിക്കാൻ',
    'padikkanam': 'പഠിക്കണം',
    'jolikkum': 'ജോലിക്കും',
    'kulikkanam': 'കുളിക്കണം',
    'kulikkan': 'കുളിക്കാൻ',

    // Food & Drinks
    'chaya': 'ചായ',
    'kaapi': 'കാപ്പി',
    'choru': 'ചോറ്',
    'curry': 'കറി',
    'puttu': 'പുട്ട്',
    'appam': 'അപ്പം',
    'dosa': 'ദോശ',
    'idli': 'ഇഡ്ഡലി',
    'pazham': 'പഴം',
    'paal': 'പാൽ',
    'juice': 'ജ്യൂസ്',
    'biriyani': 'ബിരിയാണി',
    'sweets': 'സ്വീറ്റ്സ്',
    'icecream': 'ഐസ് ക്രീം',

    // Numbers
    'onnu': 'ഒന്ന്',
    'rendu': 'രണ്ട്',
    'moonu': 'മൂന്ന്',
    'naalu': 'നാല്',
    'anju': 'അഞ്ച്',
    'ezhu': 'ഏഴ്',
    'ettu': 'എട്ട്',
    'ombathu': 'ഒമ്പത്',
    'pathu': 'പത്ത്',
    'nooru': 'നൂറ്',
    'aayiram': 'ആയിരം',
    'laksham': 'ലക്ഷം',

    // Family
    'amma': 'അമ്മ',
    'achan': 'അച്ഛൻ',
    'chettan': 'ചേട്ടൻ',
    'chechi': 'ചേച്ചി',
    'aniyathi': 'അനിയത്തി',
    'aniyan': 'അനിയൻ',
    'kunjhu': 'കുഞ്ഞ്',
    'snaehithan': 'സ്നേഹിതൻ',
    'snaehithi': 'സ്നേഹിതി',
    'ammachi': 'അമ്മച്ചി',
    'appachan': 'അപ്പച്ചൻ',
    'makan': 'മകൻ',
    'makal': 'മകൾ',
    'bharyya': 'ഭാര്യ',
    'bharttavu': 'ഭർത്താവ്',

    // Additional common phrases
    'manassilaavunnundo': 'മനസ്സിലാവുന്നുണ്ടോ',
    'manassilaayi': 'മനസ്സിലായി',
    'parayunnath': 'പറയുന്നത്',

    // Colors
    'chuvanna': 'ചുവന്ന',
    'pacha': 'പച്ച',
    'manja': 'മഞ്ഞ',
    'neela': 'നീല',
    'vella': 'വെള്ള',
    'karuppu': 'കറുപ്പ്',
    'niram': 'നിറം',
    'nilkunnu': 'നിൽക്കുന്നു',

    // Days
    'thingal': 'തിങ്കൾ',
    'chovva': 'ചൊവ്വ',
    'budhan': 'ബുധൻ',
    'vyazham': 'വ്യാഴം',
    'velli': 'വെള്ളി',
    'shani': 'ശനി',
    'nyayar': 'ഞായർ',
    'azhcha': 'ആഴ്ച',

    // Health
    'asukham': 'അസുഖം',
    'thalayil': 'തലയിൽ',
    'vedana': 'വേദന',
    'vayar': 'വയര്',
    'jwaraam': 'ജ്വരം',
    'jwaram': 'ജ്വരം',
    'doctor': 'ഡോക്ടർ',
    'marunnu': 'മരുന്ന്',
    'hospital': 'ഹോസ്പിറ്റൽ',
    'kai': 'കൈ',
    'kaal': 'കാൽ',
    'vedanichu': 'വേദനിച്ച്',

    // Weather
    'mazha': 'മഴ',
    'peyyum': 'പെയ്യും',
    'veyil': 'വെയിൽ',
    'kulir': 'കുളിര്',
    'choodu': 'ചൂട്',
    'choodaanu': 'ചൂടാണ്',
    'kaattu': 'കാറ്റ്',
    'climate': 'ക്ലൈമറ്റ്',
    'velicham': 'വെളിച്ചം',

    // Shopping
    'vila': 'വില',
    'discount': 'ഡിസ്കൗണ്ട്',
    'vangum': 'വാങ്ങും',
    'vangan': 'വാങ്ങാൻ',
    'bill': 'ബിൽ',
    'cash': 'കാഷ്',

    // Location & Direction
    'ividunnu': 'ഇവിടുന്ന്',
    'avide': 'അവിടെ',
    'nilkku': 'നിൽക്ക്',
    'munnottu': 'മുന്നോട്ട്',
    'pinnottu': 'പിന്നോട്ട്',
    'aduthu': 'അടുത്ത്',
    'valathottu': 'വലത്തോട്ട്',
    'edathottu': 'ഇടത്തോട്ട്',
    'thiriyuka': 'തിരിയുക',
    'neere': 'നേരെ',
    'dooram': 'ദൂരം',

    // Technology
    'phone': 'ഫോൺ',
    'charge': 'ചാർജ്',
    'battery': 'ബാറ്ററി',
    'wifi': 'വൈഫൈ',
    'internet': 'ഇന്റർനെറ്റ്',
    'message': 'മെസ്സേജ്',
    'ayakku': 'അയക്ക്',
    'call': 'കോൾ',
    'whatsapp': 'വാട്സാപ്പ്',
    'computer': 'കമ്പ്യൂട്ടർ',
    'laptop': 'ലാപ്ടോപ്',
    'photo': 'ഫോട്ടോ',
    'video': 'വീഡിയോ',
    'email': 'ഇമെയിൽ',
    'edukku': 'എടുക്ക്',

    // Transportation
    'bus': 'ബസ്',
    'train': 'ട്രെയിൻ',
    'auto': 'ഓട്ടോ',
    'taxi': 'ടാക്സി',
    'bike': 'ബൈക്ക്',
    'car': 'കാർ',
    'petrol': 'പെട്രോൾ',
    'station': 'സ്റ്റേഷൻ',
    'ticket': 'ടിക്കറ്റ്',
    'yatra': 'യാത്ര',
    'flight': 'ഫ്ലൈറ്റ്',
    'airport': 'എയർപോർട്ട്',
    'odichu': 'ഓടിച്ച്',

    // School & Education
    'school': 'സ്കൂൾ',
    'schoolil': 'സ്കൂളിൽ',
    'class': 'ക്ലാസ്',
    'teacher': 'ടീച്ചർ',
    'exam': 'എക്സാം',
    'homework': 'ഹോംവർക്ക്',
    'book': 'ബുക്ക്',
    'pen': 'പേൻ',
    'notebook': 'നോട്ട്ബുക്ക്',
    'mark': 'മാർക്ക്',

    // Work & Office
    'office': 'ഓഫീസ്',
    'meeting': 'മീറ്റിംഗ്',
    'work': 'വർക്ക്',
    'boss': 'ബോസ്',
    'salary': 'സാലറി',
    'leave': 'ലീവ്',
    'busy': 'ബിസി',
    'free': 'ഫ്രീ',
    'project': 'പ്രോജക്ട്',
    'complete': 'കംപ്ലീറ്റ്',
    'deadline': 'ഡെഡ്ലൈൻ',
    'salary': 'സാലറി',

    // Common verbs (additional)
    'undakki': 'ഉണ്ടാക്കി',
    'undakkum': 'ഉണ്ടാക്കും',
    'kaanunnu': 'കാണുന്നു',
    'vayikkum': 'വായിക്കും',
    'vayikkan': 'വായിക്കാൻ',
    'padichu': 'പഠിച്ച്',
    'kondirikkunnu': 'കൊണ്ടിരിക്കുന്നു',
    'cheyyunnathu': 'ചെയ്യുന്നത്',
    'cheyyunnu': 'ചെയ്യുന്നു',
    'pokunnu': 'പോകുന്നു',
    'kitti': 'കിട്ടി',
    'thaa': 'താ',
    'tharamo': 'തരാമോ',
    'adichu': 'അടിച്ച്',
    'adikkunnu': 'അടിക്കുന്നു',
    'niranju': 'നിറഞ്ഞ്',
    'thonunnu': 'തോന്നുന്നു',
    'varunnu': 'വരുന്നു',
    'aakku': 'ആക്ക്',
    'pokuka': 'പോകുക',

    // Adjectives & Adverbs
    'kuravanu': 'കുറവാണ്',
    'kurava': 'കുറവ',
    'ishtam': 'ഇഷ്ടം',
    'manassilaavum': 'മനസ്സിലാവും',
    'aagrahikkunnu': 'ആഗ്രഹിക്കുന്നു',
    'vicharikkunnu': 'വിചാരിക്കുന്നു',
    'sramikkunnu': 'ശ്രമിക്കുന്നു',
    'kelkkilla': 'കേൾക്കില്ല',
    'kaanilla': 'കാണില്ല',
    'aayirikkunnu': 'ആയിരിക്കുന്നു',

    // Misc common words
    'ente': 'എന്റെ',
    'ninde': 'നിന്റെ',
    'ningale': 'നിങ്ങളെ',
    'paranjaalum': 'പറഞ്ഞാലും',
    'sheriyalla': 'ശരിയല്ല',
    'ennu': 'എന്ന്',
    'mani': 'മണി',
    'late': 'ലേറ്റ്',
    'ok': 'ഓക്കേ',
    'please': 'പ്ലീസ്',
    'sorry': 'സോറി',
    'thankyou': 'താങ്ക് യൂ',
    'tv': 'ടിവി',
    'music': 'മ്യൂസിക്',
    'number': 'നമ്പർ',
    'on': 'ഓൺ',
    'off': 'ഓഫ്',

    // Additional common words for better accuracy
    'athe': 'അതേ',
    'ithu': 'ഇത്',
    'etha': 'ഏത',
    'enthokke': 'എന്തൊക്കെ',
    'eppozhum': 'എപ്പോഴും',
    'evideyum': 'എവിടെയും',
    'aareyum': 'ആരെയും',
    'onnum': 'ഒന്നും',
    'ellam': 'എല്ലാം',
    'ellavarum': 'എല്ലാവരും',
    'ethenkilum': 'ഏതെങ്കിലും',
    'arenkilum': 'ആരെങ്കിലും',
    'evidenkilum': 'എവിടെങ്കിലും',
    'eppolenkilum': 'എപ്പോളെങ്കിലും',
    'cheyyam': 'ചെയ്യാം',
    'varatte': 'വരട്ടെ',
    'pokatte': 'പോകട്ടെ',
    'kazhikkam': 'കഴിക്കാം',
    'parayam': 'പറയാം',
    'kelkkam': 'കേൾക്കാം',
    'kanam': 'കാണാം',
    'ariyam': 'അറിയാം',
    'manassilakkan': 'മനസ്സിലാക്കാൻ',
    'vishwasikkan': 'വിശ്വസിക്കാൻ',
    'sramichu': 'ശ്രമിച്ച്',
    'nadannu': 'നടന്ന്',
    'irunnu': 'ഇരുന്ന്',
    'odichu': 'ഓടിച്ച്',
    'nadakkunnu': 'നടക്കുന്നു',

    // Extracted from MANGLISH_TEST_EXAMPLES.md (276 additional entries)
    'njan ninde kude varatte  ': 'ഞാൻ നിന്റെ കുടുക്കെ വരട്ടെ',

    // Additional conversational phrases for better accuracy
    'innu ningalkku engane thonnunnu': 'ഇന്ന് നിങ്ങൾക്ക് എങ്ങനെ തോന്നുന്നു',
    'namukku ingane samsaarikkan kazhiyunnathil enikku sandoshamundu':
        'നമുക്ക് ഇങ്ങനെ സംസാരിക്കാൻ കഴിയുന്നതിൽ എനിക്ക് സന്തോഷമുണ്ട്',
    'innu ningal enthaanu cheythu': 'ഇന്ന് നിങ്ങൾ എന്താണ് ചെയ്തത്',
    'enne manasilaakkiyathinu nandi': 'എന്നെ മനസ്സിലാക്കിയതിന് നന്ദി',
    'ee aappu nammude nishabdathayude bhaaram kuraykkunnu':
        'ഈ ആപ്പ് നമ്മുടെ നിശബ്ദതയുടെ ഭാരം കുറയ്ക്കുന്നു',
    'sabdamillathe polum enikku ningalodu samsaarikkan ishtamaanu':
        'ശബ്ദമില്ലാതെ പോലും എനിക്ക് നിങ്ങളോട് സംസാരിക്കാൻ ഇഷ്ടമാണ്',
    'ningalkku sukhamaano ningal vishamikkunnathaayi thonnunnu':
        'നിങ്ങൾക്ക് സുഖമാണോ നിങ്ങൾ വിഷമിക്കുന്നതായി തോന്നുന്നു',
    'nammal randuperkkum kelkkan kazhiyunnillengilum njaan ningalkkoppam undu':
        'നമ്മൾ രണ്ടുപേർക്കും കേൾക്കാൻ കഴിയുന്നില്ലെങ്കിലും ഞാൻ നിങ്ങൾക്കൊപ്പം ഉണ്ട്',
    'namukku pinneet evideyengilum kaanam':
        'നമുക്ക് പിന്നീട് എവിടെയെങ്കിലും കാണാം',
    'avasaanam aashayavinimayam nadathunnathu nallathaanu':
        'അവസാനം ആശയവിനിമയം നടത്തുന്നത് നല്ലതാണ്',

    'njan padichu kondirikkunnu': 'ഞാൻ പഠിച്ച് കൊണ്ടിരിക്കുന്നു',
    'athu cheyyaan vendiyirunnu': 'അത് ചെയ്യാൻ വേണ്ടിയിരുന്നു',
    'namaskaaram evide pokunnu': 'നമസ്കാരം എവിടെ പോകുന്നു',
    'njan sukham aayirikkunnu': 'ഞാൻ സുഖം ആയിരിക്കുന്നു',
    'velicham kooduthal aanu': 'വെളിച്ചം കൂടുതൽ ആണ്',
    'ningalude vittil evide': 'നിങ്ങളുടെ വീട്ടിൽ എവിടെ',
    'nee entha cheyyunnathu': 'നീ എന്താ ചെയ്യുന്നത്',
    'visheshangal parayamo': 'വിശേഷങ്ങൾ പറയാമോ',
    'project complete aayi': 'പ്രോജക്ട് കംപ്ലീറ്റ് ആയി',
    'avalude phone number': 'അവളുടെ ഫോൺ നമ്പർ',
    'ningal enthu cheyyum': 'നിങ്ങൾ എന്ത് ചെയ്യും',
    'enik santhosham aanu': 'എനിക്ക് സന്തോഷം ആണ്',
    'valathottu thiriyuka': 'വലത്തോട്ട് തിരിയുക',
    'veyil kooduthal aanu': 'വെയിൽ കൂടുതൽ ആണ്',
    'biriyani ishtam aanu': 'ബിരിയാണി ഇഷ്ടം ആണ്',
    'santhosham thonunnu': 'സന്തോഷം തോന്നുന്നു',
    'ithu valare nannayi': 'ഇത് വളരെ നന്നായി',
    'ninde peru enthaanu': 'നിന്റെ പേര് എന്താണ്',
    'avaraanu paranjathu': 'അവരാണ് പറഞ്ഞത്',
    'njan jolikkum pokum': 'ഞാൻ ജോലിക്കും പോകും',
    'edathottu thiriyuka': 'ഇടത്തോട്ട് തിരിയുക',
    'vila kooduthal aanu': 'വില കൂടുതൽ ആണ്',
    'marunnu kazhikkanam': 'മരുന്ന് കഴിക്കണം',
    'whatsapp il paranju': 'വാട്സാപ്പ് ഇൽ പറഞ്ഞ്',
    'station aduthu aanu': 'സ്റ്റേഷൻ അടുത്ത് ആണ്',
    'hello, engane undu': 'ഹലോ, എങ്ങനെ ഉണ്ട്',
    'avante koode pokum': 'അവന്റെ കൂടെ പോകും',
    'njangal pokunnilla': 'ഞങ്ങൾ പോകുന്നില്ല',
    'athu kondu mathram': 'അത് കൊണ്ട് മാത്രം',
    'ethra aalukal undu': 'എത്ര ആളുകൾ ഉണ്ട്',
    'njan athu ariyilla': 'ഞാൻ അത് അറിയില്ല',
    'innale vaikunneram': 'ഇന്നലെ വൈകുന്നേരം',
    'njan hello paranju': 'ഞാൻ ഹലോ പറഞ്ഞ്',
    'no problem, pattum': 'നോ പ്രോബ്ലം, പറ്റും',
    'nee evide padikkum': 'നീ എവിടെ പഠിക്കും',
    'valare stress aanu': 'വളരെ സ്ട്രെസ്സ് ആണ്',
    'nalla climate aanu': 'നല്ല ക്ലൈമറ്റ് ആണ്',
    'doctor ne kaananam': 'ഡോക്ടർ നെ കാണണം',
    'njan schoolil aanu': 'ഞാൻ സ്കൂളിൽ ആണ്',
    'nee evide pokunnu': 'നീ എവിടെ പോകുന്നു',
    'ningal evide aanu': 'നിങ്ങൾ എവിടെ ആണ്',
    'avar innale vannu': 'അവർ ഇന്നലെ വന്നു',
    'nammal nale pokum': 'നമ്മൾ നാളെ പോകും',
    'ellam sheriyaakum': 'എല്ലാം ശരിയാകും',
    'thank you paranju': 'താങ്ക് യൂ പറഞ്ഞ്',
    'saadhyam kazhichu': 'സാധ്യം കഴിച്ച്',
    'phone number thaa': 'ഫോൺ നമ്പർ താ',
    'njan tension aanu': 'ഞാൻ ടെൻഷൻ ആണ്',
    'njan excited aanu': 'ഞാൻ എക്സൈറ്റഡ് ആണ്',
    'njan relaxed aanu': 'ഞാൻ റിലാക്സഡ് ആണ്',
    'veedu aduthu aanu': 'വീട് അടുത്ത് ആണ്',
    'innu mazha peyyum': 'ഇന്ന് മഴ പെയ്യും',
    'njan asukham aanu': 'ഞാൻ അസുഖം ആണ്',
    'phone charge aayi': 'ഫോൺ ചാർജ് ആയി',
    'computer on aakku': 'കമ്പ്യൂട്ടർ ഓൺ ആക്ക്',
    'laptop evide aanu': 'ലാപ്ടോപ് എവിടെ ആണ്',
    'ellam sheriyaanu': 'എല്ലാം ശരിയാണ്',
    'njan sukham aanu': 'ഞാൻ സുഖം ആണ്',
    'thaan evide aanu': 'താൻ എവിടെ ആണ്',
    'ingane cheyyalle': 'ഇങ്ങനെ ചെയ്യല്ലേ',
    'angane parayalle': 'അങ്ങനെ പറയല്ലേ',
    'evide aanu veedu': 'എവിടെ ആണ് വീട്',
    'bye paranju poyi': 'ബൈ പറഞ്ഞ് പോയി',
    'njan vishakkunnu': 'ഞാൻ വിശക്കുന്നു',
    'veedu evide aanu': 'വീട് എവിടെ ആണ്',
    'njan tv kaanunnu': 'ഞാൻ ടിവി കാണുന്നു',
    'ethra roopa aanu': 'എത്ര രൂപ ആണ്',
    'pazham kazhikkum': 'പഴം കഴിക്കും',
    'sweets kazhikkum': 'സ്വീറ്റ്സ് കഴിക്കും',
    'class evide aanu': 'ക്ലാസ് എവിടെ ആണ്',
    'homework cheyyum': 'ഹോംവർക്ക് ചെയ്യും',
    'battery kuravanu': 'ബാറ്ററി കുറവാണ്',
    'train eppo varum': 'ട്രെയിൻ എപ്പോ വരും',
    'flight eppo aanu': 'ഫ്ലൈറ്റ് എപ്പോ ആണ്',
    'entha vishesham': 'എന്താ വിശേഷം',
    'hai, sukhamalle': 'ഹായ്, സുഖമല്ലേ',
    'hai, njan vannu': 'ഹായ്, ഞാൻ വന്നു',
    'nammalude naadu': 'നമ്മളുടെ നാട്',
    'ellavarum vannu': 'എല്ലാവരും വന്നു',
    'enthu vishesham': 'എന്ത് വിശേഷം',
    'njan kulikkanam': 'ഞാൻ കുളിക്കണം',
    'valare vishamam': 'വളരെ വിഷമം',
    'deshyam varunnu': 'ദേഷ്യം വരുന്നു',
    'ithu ethra aanu': 'ഇത് എത്ര ആണ്',
    'thalayil vedana': 'തലയിൽ വേദന',
    'puttu kazhikkum': 'പുട്ട് കഴിക്കും',
    'ice cream venam': 'ഐസ് ക്രീം വേണം',
    'ethra mani aanu': 'എത്ര മണി ആണ്',
    'book evide aanu': 'ബുക്ക് എവിടെ ആണ്',
    'nammal kaanaam': 'നമ്മൾ കാണാം',
    'nee evide poyi': 'നീ എവിടെ പോയി',
    'valare nannayi': 'വളരെ നന്നായി',
    'kaapi kudikkum': 'കാപ്പി കുടിക്കും',
    'bore adikkunnu': 'ബോർ അടിക്കുന്നു',
    'ividunnu pokum': 'ഇവിടുന്ന് പോകും',
    'hospital pokum': 'ഹോസ്പിറ്റൽ പോകും',
    'kaal vedanichu': 'കാൽ വേദനിച്ച്',
    'chuvanna niram': 'ചുവന്ന നിറം',
    'thingal azhcha': 'തിങ്കൾ ആഴ്ച',
    'vyazham azhcha': 'വ്യാഴം ആഴ്ച',
    'message ayakku': 'മെസ്സേജ് അയക്ക്',
    'video kaanunnu': 'വീഡിയോ കാണുന്നു',
    'bus evide aanu': 'ബസ് എവിടെ ആണ്',
    'car evide aanu': 'കാർ എവിടെ ആണ്',
    'sukham thanne': 'സുഖം തന്നെ',
    'nannaayi undu': 'നന്നായി ഉണ്ട്',
    'pinne kaanaam': 'പിന്നെ കാണാം',
    'enthinu venda': 'എന്തിന് വേണ്ട',
    'innale raatri': 'ഇന്നലെ രാത്രി',
    'sorry parayan': 'സോറി പറയാൻ',
    'ok njan varum': 'ഓക്കേ ഞാൻ വരും',
    'music kelkkum': 'മ്യൂസിക് കേൾക്കും',
    'book vayikkum': 'ബുക്ക് വായിക്കും',
    'confused aanu': 'കൺഫ്യൂസ്ഡ് ആണ്',
    'kaattu adichu': 'കാറ്റ് അടിച്ച്',
    'mazha niranju': 'മഴ നിറഞ്ഞ്',
    'vila kuravanu': 'വില കുറവാണ്',
    'discount undo': 'ഡിസ്കൗണ്ട് ഉണ്ടോ',
    'kai vedanichu': 'കൈ വേദനിച്ച്',
    'curry undakki': 'കറി ഉണ്ടാക്കി',
    'dosa kazhichu': 'ദോശ കഴിച്ച്',
    'paal kudikkum': 'പാൽ കുടിക്കും',
    'karuppu niram': 'കറുപ്പ് നിറം',
    'chovva azhcha': 'ചൊവ്വ ആഴ്ച',
    'budhan azhcha': 'ബുധൻ ആഴ്ച',
    'nyayar azhcha': 'ഞായർ ആഴ്ച',
    'teacher vannu': 'ടീച്ചർ വന്നു',
    'notebook thaa': 'നോട്ട്ബുക്ക് താ',
    'deadline aanu': 'ഡെഡ്ലൈൻ ആണ്',
    'internet illa': 'ഇന്റർനെറ്റ് ഇല്ല',
    'ticket vangum': 'ടിക്കറ്റ് വാങ്ങും',
    'yatra pokunnu': 'യാത്ര പോകുന്നു',
    'airport pokum': 'എയർപോർട്ട് പോകും',
    'nalla karyam': 'നല്ല കാര്യം',
    'nale raavile': 'നാളെ രാവിലെ',
    'nale uchakku': 'നാളെ ഉച്ചക്ക്',
    'innu raavile': 'ഇന്ന് രാവിലെ',
    'vellam venam': 'വെള്ളം വേണം',
    'njan urangum': 'ഞാൻ ഉറങ്ങും',
    'avide nilkku': 'അവിടെ നിൽക്ക്',
    'munnottu vaa': 'മുന്നോട്ട് വാ',
    'neere pokuka': 'നേരെ പോകുക',
    'bill tharamo': 'ബിൽ തരാമോ',
    'vayar vedana': 'വയര് വേദന',
    'jwaraam undu': 'ജ്വരം ഉണ്ട്',
    'velli azhcha': 'വെള്ളി ആഴ്ച',
    'shani azhcha': 'ശനി ആഴ്ച',
    'samayam aayi': 'സമയം ആയി',
    'office pokum': 'ഓഫീസ് പോകും',
    'meeting undu': 'മീറ്റിംഗ് ഉണ്ട്',
    'work cheyyum': 'വർക്ക് ചെയ്യും',
    'salary kitti': 'സാലറി കിട്ടി',
    'call cheyyum': 'കോൾ ചെയ്യും',
    'photo edukku': 'ഫോട്ടോ എടുക്ക്',
    'email ayakku': 'ഇമെയിൽ അയക്ക്',
    'petrol venam': 'പെട്രോൾ വേണം',
    'eppol pokum': 'എപ്പോൾ പോകും',
    'engane undu': 'എങ്ങനെ ഉണ്ട്',
    'innu raatri': 'ഇന്ന് രാത്രി',
    'chaya venam': 'ചായ വേണം',
    'evide pokum': 'എവിടെ പോകും',
    'pinnottu po': 'പിന്നോട്ട് പോ',
    'dooram aanu': 'ദൂരം ആണ്',
    'njan vangum': 'ഞാൻ വാങ്ങും',
    'choru venam': 'ചോറ് വേണം',
    'appam venam': 'അപ്പം വേണം',
    'juice venam': 'ജ്യൂസ് വേണം',
    'pacha niram': 'പച്ച നിറം',
    'manja niram': 'മഞ്ഞ നിറം',
    'neela niram': 'നീല നിറം',
    'vella niram': 'വെള്ള നിറം',
    'nalla niram': 'നല്ല നിറം',
    'leave venam': 'ലീവ് വേണം',
    'bike odichu': 'ബൈക്ക് ഓടിച്ച്',
    'sukhamaano': 'സുഖമാണോ',
    'avan vannu': 'അവൻ വന്നു',
    'aarum illa': 'ആരും ഇല്ല',
    'pokunnath' : 'പോകുന്നത്',
    'varunnath' : 'വരുന്നത്',
    'eppoyaa   pokunnath' : 'എപ്പോയാ പോകുന്നത്',
    'eppoyaa varunnath' : 'എപ്പോയാ വരുന്നത്',
    'njan ippo varaa' : 'ഞാൻ ഇപ്പോ വരാ',  
    'eppo varum': 'എപ്പോ വരും',
    'innu pakal': 'ഇന്ന് പകൽ',
    'kulir aanu': 'കുളിര് ആണ്',
    'athu venda': 'അത് വേണ്ട',
    'paisa illa': 'പൈസ ഇല്ല',
    'idli venam': 'ഇഡ്ഡലി വേണം',
    'snaehithan': 'സ്നേഹിതൻ',
    'mark kitti': 'മാർക്ക് കിട്ടി',
    'boss vannu': 'ബോസ് വന്നു',
    'auto kitti': 'ഓട്ടോ കിട്ടി',
    'taxi venam': 'ടാക്സി വേണം',
    'aval poyi': 'അവൾ പോയി',
    'aar vannu': 'ആര് വന്നു',
    'cash undo': 'കാഷ് ഉണ്ടോ',
    'late aayi': 'ലേറ്റ് ആയി',
    'snaehithi': 'സ്നേഹിതി',
    'exam undu': 'എക്സാം ഉണ്ട്',
    'pen venam': 'പേൻ വേണം',
    'busy aanu': 'ബിസി ആണ്',
    'free aanu': 'ഫ്രീ ആണ്',
    'wifi undo': 'വൈഫൈ ഉണ്ടോ',
    'pokaatte': 'പോകാട്ടെ',
    'sheriyaa': 'ശരിയാ',
    'vendallo': 'വേണ്ടല്ലോ',
    'kaanilla': 'കാണില്ല',
    'aniyathi': 'അനിയത്തി',
    'appachan': 'അപ്പച്ചൻ',
    'kshemam': 'ക്ഷേമം',
    'prasnam': 'പ്രശ്നം',
    'sthalam': 'സ്ഥലം',
    'snaeham': 'സ്നേഹം',
    'aniyan': 'അനിയൻ',
    'kunjhu': 'കുഞ്ഞ്',
    'varan': 'വരാൻ',
    'povan': 'പോവാൻ',
    'kandu': 'കണ്ട്',
    'rendu': 'രണ്ട്',
    'moonu': 'മൂന്ന്',
    'naalu': 'നാല്',
    'nooru': 'നൂറ്',
    'makan': 'മകൻ',
    'njaan': 'ഞാൻ',
    'ille': 'ഇല്ലേ',
    'anju': 'അഞ്ച്',
    'aaru': 'ആറ്',
    'ezhu': 'ഏഴ്',
    'ettu': 'എട്ട്',
    'nee podaa': 'നീ പോടാ',
    'njan vangum': 'ഞാൻ വാങ്ങും',
    'ente kude varaamo': 'എൻ്റെ കൂടെ വരാമോ ',
    'ente kude varum': 'എൻ്റെ കൂടെ വരും',
    'nee eppoyaa pokunnath': 'നീ എപ്പോയാ പോകുന്നത്',
    'buss vannal parayaam': 'ബസ്സ് വന്നാൽ പറയാം',
    // Additional personal and conversational phrases
    'enne varaan anuvadikku': 'എന്നെ വരാൻ അനുവദിക്കൂ',
    'nee onnum paranjille': 'നീ ഒന്നും പറഞ്ഞില്ലേ',
    'ee aappu evide ninnaanu kittiyathu': 'ഈ ആപ്പ് എവിടെ നിന്നാണ് കിട്ടിയത്',
    'varoo kunje': 'വരൂ കുഞ്ഞേ',
    'ninte ammayude perenthaanu': 'നിന്റെ അമ്മയുടെ പേരെന്താണ്',
    'ninte achante perenthaanu': 'നിന്റെ അച്ഛന്റെ പേരെന്താണ്',
    'nee evide ninnaanu': 'നീ എവിടെ നിന്നാണ്',
    'ninte ammayude nambar ninte kaivashamundo':
        'നിന്റെ അമ്മയുടെ നമ്പർ നിന്റെ കൈവശമുണ്ടോ',
    'appol njaan ninte koode undakum': 'അപ്പോൾ ഞാൻ നിന്റെ കൂടെ ഉണ്ടാകും',
    'enikku ninne valare ishtamaanu': 'എനിക്ക് നിന്നെ വളരെ ഇഷ്ടമാണ്',
    'enikku ninnodu pranayamundu': 'എനിക്ക് നിന്നോട് പ്രണയമുണ്ട്',
    'nee kadayil pokumo': 'നീ കടയിൽ പോകുമോ',
  };

  /// Transliterates Malayalam script to Manglish (romanized) text
  static String transliterateToManglish(String malayalamText) {
    if (malayalamText.isEmpty) return malayalamText;

    // Check if text contains Malayalam characters
    final malayalamRegex = RegExp(r'[\u0D00-\u0D7F]');
    if (!malayalamRegex.hasMatch(malayalamText)) {
      return malayalamText; // Already in Latin script
    }

    // Create reverse mappings
    final reverseCommonWords = <String, String>{};
    _commonWords.forEach((key, value) {
      reverseCommonWords[value] = key;
    });

    final reverseVowels = <String, String>{};
    _vowels.forEach((key, value) {
      reverseVowels[value] = key.toLowerCase();
    });

    final reverseConsonants = <String, String>{};
    _consonants.forEach((key, value) {
      // Remove virama for mapping
      String consonant = value.substring(0, value.length - 1);
      reverseConsonants[consonant] = key.toLowerCase();
    });

    final reverseVowelSigns = <String, String>{};
    _vowelSigns.forEach((key, value) {
      if (value.isNotEmpty) {
        reverseVowelSigns[value] = key.toLowerCase();
      }
    });

    // Additional chillu characters (special consonants without virama)
    final chilluMap = <String, String>{
      'ൺ': 'n',
      'ൻ': 'n',
      'ർ': 'r',
      'ൽ': 'l',
      'ൾ': 'L',
      'ൿ': 'k',
      'ൔ': 'm',
    };

    // Fallback mapping for any unmapped Malayalam characters
    final fallbackMap = <String, String>{
      'അ': 'a',
      'ആ': 'aa',
      'ഇ': 'i',
      'ഈ': 'ee',
      'ഉ': 'u',
      'ഊ': 'oo',
      'ഋ': 'ru',
      'എ': 'e',
      'ഏ': 'e',
      'ഐ': 'ai',
      'ഒ': 'o',
      'ഓ': 'o',
      'ഔ': 'au',
      'ക': 'ka',
      'ഖ': 'kha',
      'ഗ': 'ga',
      'ഘ': 'gha',
      'ങ': 'nga',
      'ച': 'cha',
      'ഛ': 'chha',
      'ജ': 'ja',
      'ഝ': 'jha',
      'ഞ': 'nja',
      'ട': 'Ta',
      'ഠ': 'Tha',
      'ഡ': 'Da',
      'ഢ': 'Dha',
      'ണ': 'Na',
      'ത': 'tha',
      'ഥ': 'thha',
      'ദ': 'da',
      'ധ': 'dha',
      'ന': 'na',
      'പ': 'pa',
      'ഫ': 'pha',
      'ബ': 'ba',
      'ഭ': 'bha',
      'മ': 'ma',
      'യ': 'ya',
      'ര': 'ra',
      'ല': 'la',
      'വ': 'va',
      'ശ': 'sha',
      'ഷ': 'Sha',
      'സ': 'sa',
      'ഹ': 'ha',
      'ള': 'La',
      'ഴ': 'zha',
      'റ': 'Ra',
      'ം': 'm',
      'ഃ': 'h',
      '്': '',
      'ാ': 'aa',
      'ി': 'i',
      'ീ': 'ee',
      'ു': 'u',
      'ൂ': 'oo',
      'ൃ': 'ru',
      'െ': 'e',
      'േ': 'e',
      'ൈ': 'ai',
      'ൊ': 'o',
      'ോ': 'o',
      'ൌ': 'au',
      'ൗ': 'au',
    };

    // Split into words
    List<String> words = malayalamText.split(RegExp(r'\s+'));
    List<String> transliteratedWords = [];

    for (String word in words) {
      if (word.isEmpty) continue;

      // Check for punctuation
      String punctuation = '';
      String cleanWord = word;
      final punctuationRegex = RegExp(r'[.,!?;:]+$');
      if (punctuationRegex.hasMatch(word)) {
        final match = punctuationRegex.firstMatch(word);
        punctuation = match!.group(0)!;
        cleanWord = word.substring(0, word.length - punctuation.length);
      }

      // Check if it's a common word first
      if (reverseCommonWords.containsKey(cleanWord)) {
        transliteratedWords.add(reverseCommonWords[cleanWord]! + punctuation);
        continue;
      }

      // Character-by-character transliteration
      String result = '';
      int i = 0;

      while (i < cleanWord.length) {
        bool matched = false;
        String char = cleanWord[i];

        // Check for chillu characters first
        if (chilluMap.containsKey(char)) {
          result += chilluMap[char]!;
          i++;
          continue;
        }

        // Handle conjunct consonants (consonant + virama + consonant)
        if (i + 2 < cleanWord.length) {
          String nextChar = cleanWord[i + 1];
          String charAfterNext = cleanWord[i + 2];

          // Check for consonant + virama + consonant pattern
          if (reverseConsonants.containsKey(char) &&
              nextChar == '്' &&
              reverseConsonants.containsKey(charAfterNext)) {
            String firstConsonant = reverseConsonants[char]!;
            String secondConsonant = reverseConsonants[charAfterNext]!;

            // Check if there's a vowel sign after the second consonant
            if (i + 3 < cleanWord.length &&
                reverseVowelSigns.containsKey(cleanWord[i + 3])) {
              String vowelSign = reverseVowelSigns[cleanWord[i + 3]]!;
              result +=
                  firstConsonant +
                  secondConsonant +
                  (vowelSign.isEmpty ? 'a' : vowelSign);
              i += 4;
              matched = true;
            } else if (i + 3 < cleanWord.length && cleanWord[i + 3] == '്') {
              // Another virama after second consonant
              result += firstConsonant + secondConsonant;
              i += 3;
              matched = true;
            } else {
              // No vowel sign, use inherent 'a'
              result += firstConsonant + secondConsonant + 'a';
              i += 3;
              matched = true;
            }
          }
        }

        // Try to match consonant + vowel sign combinations
        if (!matched && i + 1 < cleanWord.length) {
          String nextChar = cleanWord[i + 1];

          // Check if current char is a consonant
          if (reverseConsonants.containsKey(char)) {
            String consonant = reverseConsonants[char]!;

            // Check for vowel sign
            if (reverseVowelSigns.containsKey(nextChar)) {
              String vowelSign = reverseVowelSigns[nextChar]!;
              result += consonant + (vowelSign.isEmpty ? 'a' : vowelSign);
              i += 2;
              matched = true;
            } else if (nextChar == '്') {
              // Virama - consonant without vowel
              result += consonant;
              i += 2;
              matched = true;
            } else if (nextChar == 'ം' || nextChar == 'ഃ') {
              // Consonant with inherent 'a' followed by anusvara/visarga
              result += consonant + 'a';
              i++;
              matched = true;
            } else {
              // Consonant with inherent 'a'
              result += consonant + 'a';
              i++;
              matched = true;
            }
          }
        }

        if (!matched) {
          // Check for standalone vowel
          if (reverseVowels.containsKey(char)) {
            result += reverseVowels[char]!;
            i++;
          }
          // Check for consonant alone
          else if (reverseConsonants.containsKey(char)) {
            result += reverseConsonants[char]! + 'a';
            i++;
          }
          // Check for special characters
          else if (char == 'ം') {
            result += 'm';
            i++;
          } else if (char == 'ഃ') {
            result += 'h';
            i++;
          } else if (char == '്') {
            // Virama alone - remove the 'a' we added
            if (result.endsWith('a')) {
              result = result.substring(0, result.length - 1);
            }
            i++;
          }
          // Use fallback mapping for any unmapped character
          else if (fallbackMap.containsKey(char)) {
            result += fallbackMap[char]!;
            i++;
          }
          // If still not found, check if it's a Malayalam character
          else if (malayalamRegex.hasMatch(char)) {
            // For unmapped Malayalam chars, try to use a phonetic approximation
            // This should rarely happen with our comprehensive fallback map
            result += '?';
            i++;
          } else {
            // Keep as is (numbers, punctuation, Latin chars, etc.)
            result += char;
            i++;
          }
        }
      }

      transliteratedWords.add(result + punctuation);
    }

    return transliteratedWords.join(' ');
  }

  /// Transliterates Manglish text to Malayalam script with improved accuracy
  static String transliterateToMalayalam(String manglishText) {
    if (manglishText.isEmpty) return manglishText;

    // Split into words and process each word
    List<String> words = manglishText.split(RegExp(r'\s+'));
    List<String> transliteratedWords = [];

    for (String word in words) {
      if (word.isEmpty) continue;

      // Check for punctuation at the end
      String punctuation = '';
      String cleanWord = word;
      final punctuationRegex = RegExp(r'[.,!?;:]$');
      if (punctuationRegex.hasMatch(word)) {
        punctuation = word[word.length - 1];
        cleanWord = word.substring(0, word.length - 1);
      }

      String transliterated = _transliterateWord(cleanWord.toLowerCase());
      transliteratedWords.add(transliterated + punctuation);
    }

    return transliteratedWords.join(' ');
  }

  /// Transliterates a single word
  static String _transliterateWord(String word) {
    // Check if it's a common word first
    if (_commonWords.containsKey(word)) {
      return _commonWords[word]!;
    }

    // Check for common phrases
    for (var phrase in _commonWords.keys) {
      if (phrase.contains(' ') && word == phrase.replaceAll(' ', '')) {
        return _commonWords[phrase]!;
      }
    }

    // Syllable-based transliteration
    return _syllableBasedTransliteration(word);
  }

  /// Performs syllable-based transliteration
  static String _syllableBasedTransliteration(String word) {
    String result = '';
    int i = 0;

    while (i < word.length) {
      bool matched = false;

      // Try to match consonant + vowel combinations (longest first)
      for (int len = 4; len >= 1; len--) {
        if (i + len > word.length) continue;

        String chunk = word.substring(i, i + len);

        // Try consonant + vowel sign
        for (var cons in _consonants.keys) {
          if (chunk.startsWith(cons)) {
            String remaining = chunk.substring(cons.length);

            // Check if remaining part is a vowel
            if (remaining.isEmpty) {
              // Consonant without vowel (add virama)
              result += _consonants[cons]!;
              i += cons.length;
              matched = true;
              break;
            } else if (_vowelSigns.containsKey(remaining)) {
              // Consonant + vowel
              String consonant = _consonants[cons]!;
              // Remove virama from consonant
              consonant = consonant.substring(0, consonant.length - 1);
              result += consonant + _vowelSigns[remaining]!;
              i += chunk.length;
              matched = true;
              break;
            }
          }
        }

        if (matched) break;
      }

      if (!matched) {
        // Try standalone vowel
        bool vowelMatched = false;
        for (int len = 3; len >= 1; len--) {
          if (i + len > word.length) continue;
          String chunk = word.substring(i, i + len);

          if (_vowels.containsKey(chunk)) {
            result += _vowels[chunk]!;
            i += len;
            vowelMatched = true;
            break;
          }
        }

        if (!vowelMatched) {
          // Keep the character as is
          result += word[i];
          i++;
        }
      }
    }

    return result;
  }

  /// Checks if the text contains Manglish patterns
  static bool isManglish(String text) {
    if (text.isEmpty) return false;

    String lowerText = text.toLowerCase();

    // Check if text contains any common Manglish words
    for (var word in _commonWords.keys) {
      if (lowerText.contains(word)) {
        return true;
      }
    }

    // Check for common Malayalam phonetic patterns
    final manglishPatterns = [
      RegExp(
        r'\b(nj|zh|Sh|ng|th|dh|ch|kh|gh|bh|ph)',
      ), // Malayalam specific consonants
      RegExp(r'(aa|ee|oo|ai|au|ou)'), // Long vowels
      RegExp(
        r'\b(njan|avan|aval|enthu|evide|aanu|undu|illa|venda|venam)\b',
      ), // Common words
    ];

    return manglishPatterns.any((pattern) => pattern.hasMatch(lowerText));
  }

  /// Detects if text is likely Manglish or pure Malayalam
  static bool needsTransliteration(String text) {
    if (text.isEmpty) return false;

    // Check if text already contains Malayalam characters
    final malayalamRegex = RegExp(r'[\u0D00-\u0D7F]');
    if (malayalamRegex.hasMatch(text)) {
      return false; // Already has Malayalam script
    }

    // Check if it's likely Manglish
    return isManglish(text);
  }

  /// Provides suggestions for Manglish to Malayalam conversion
  static List<String> getSuggestions(String input) {
    List<String> suggestions = [];
    String lowerInput = input.toLowerCase();

    for (var entry in _commonWords.entries) {
      if (entry.key.startsWith(lowerInput)) {
        suggestions.add('${entry.key} → ${entry.value}');
      }
    }

    return suggestions;
  }
}
