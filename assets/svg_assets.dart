// SVG Assets for Naka App
const String findWorkerSVG = '''<svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
  <!-- Background Circle -->
  <circle cx="100" cy="100" r="95" fill="#E8F4F8" stroke="#17A2B8" stroke-width="2"/>
  
  <!-- Worker Head -->
  <circle cx="100" cy="60" r="20" fill="#FFD4A3"/>
  
  <!-- Worker Body -->
  <rect x="85" y="85" width="30" height="35" fill="#4A90E2" rx="3"/>
  
  <!-- Worker Arms -->
  <rect x="60" y="90" width="25" height="12" fill="#FFD4A3" rx="6"/>
  <rect x="115" y="90" width="25" height="12" fill="#FFD4A3" rx="6"/>
  
  <!-- Worker Legs -->
  <rect x="88" y="120" width="8" height="25" fill="#333333"/>
  <rect x="104" y="120" width="8" height="25" fill="#333333"/>
  
  <!-- Shoes -->
  <rect x="85" y="145" width="12" height="6" fill="#666666" rx="2"/>
  <rect x="103" y="145" width="12" height="6" fill="#666666" rx="2"/>
  
  <!-- Happy Face -->
  <circle cx="95" cy="55" r="2" fill="#333333"/>
  <circle cx="105" cy="55" r="2" fill="#333333"/>
  <path d="M 95 62 Q 100 65 105 62" stroke="#333333" stroke-width="1.5" fill="none" stroke-linecap="round"/>
  
  <!-- Checkmark -->
  <circle cx="155" cy="50" r="18" fill="#17A2B8"/>
  <path d="M 148 58 L 152 62 L 162 48" stroke="white" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
</svg>''';

const String postJobSVG = '''<svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
  <!-- Background Circle -->
  <circle cx="100" cy="100" r="95" fill="#F0E8F8" stroke="#17A2B8" stroke-width="2"/>
  
  <!-- Document/Form -->
  <rect x="60" y="50" width="80" height="110" fill="white" stroke="#17A2B8" stroke-width="2" rx="4"/>
  
  <!-- Document Lines -->
  <line x1="70" y1="65" x2="130" y2="65" stroke="#999" stroke-width="1.5"/>
  <line x1="70" y1="75" x2="130" y2="75" stroke="#999" stroke-width="1.5"/>
  <line x1="70" y1="85" x2="120" y2="85" stroke="#999" stroke-width="1.5"/>
  
  <!-- Text Block -->
  <rect x="70" y="95" width="60" height="8" fill="#E8F4F8" rx="2"/>
  <line x1="70" y1="108" x2="130" y2="108" stroke="#999" stroke-width="1.5"/>
  <line x1="70" y1="118" x2="115" y2="118" stroke="#999" stroke-width="1.5"/>
  
  <!-- Pencil Icon -->
  <rect x="135" y="135" width="30" height="4" fill="#17A2B8" transform="rotate(-45 150 137)" rx="2"/>
  <polygon points="155,120 160,125 158,127" fill="#FFA500"/>
  
  <!-- Plus Icon -->
  <circle cx="155" cy="155" r="15" fill="#17A2B8"/>
  <line x1="155" y1="148" x2="155" y2="162" stroke="white" stroke-width="2" stroke-linecap="round"/>
  <line x1="148" y1="155" x2="162" y2="155" stroke="white" stroke-width="2" stroke-linecap="round"/>
</svg>''';

const String connectSVG = '''<svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
  <!-- Background Circle -->
  <circle cx="100" cy="100" r="95" fill="#E8F8F0" stroke="#17A2B8" stroke-width="2"/>
  
  <!-- Left Person -->
  <circle cx="50" cy="55" r="15" fill="#FFD4A3"/>
  <rect x="40" y="75" width="20" height="25" fill="#4A90E2" rx="2"/>
  <rect x="25" y="78" width="15" height="10" fill="#FFD4A3" rx="5"/>
  <rect x="60" y="78" width="15" height="10" fill="#FFD4A3" rx="5"/>
  
  <!-- Right Person -->
  <circle cx="150" cy="55" r="15" fill="#FFD4A3"/>
  <rect x="140" y="75" width="20" height="25" fill="#FF6B6B" rx="2"/>
  <rect x="125" y="78" width="15" height="10" fill="#FFD4A3" rx="5"/>
  <rect x="160" y="78" width="15" height="10" fill="#FFD4A3" rx="5"/>
  
  <!-- Connection Line with Nodes -->
  <line x1="65" y1="95" x2="135" y2="95" stroke="#17A2B8" stroke-width="2"/>
  <circle cx="80" cy="95" r="4" fill="#17A2B8"/>
  <circle cx="100" cy="95" r="6" fill="#FFD700"/>
  <circle cx="120" cy="95" r="4" fill="#17A2B8"/>
  
  <!-- Chat Bubbles -->
  <path d="M 40 115 Q 35 120 40 125 L 70 125 Q 75 120 70 115 Z" fill="#4A90E2" opacity="0.3"/>
  <circle cx="130" cy="125" r="8" fill="#FF6B6B" opacity="0.3"/>
  
  <!-- Heart Icon -->
  <path d="M 100 150 C 100 150 90 140 85 135 C 80 130 75 135 75 140 C 75 150 100 165 100 165 C 100 165 125 150 125 140 C 125 135 120 130 115 135 C 110 140 100 150 100 150" fill="#FF6B6B"/>
</svg>''';

const String earnSVG = '''<svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
  <!-- Background Circle -->
  <circle cx="100" cy="100" r="95" fill="#F8F8E8" stroke="#17A2B8" stroke-width="2"/>
  
  <!-- Coin Stack -->
  <circle cx="70" cy="120" r="20" fill="#FFD700" stroke="#FFA500" stroke-width="2"/>
  <text x="70" y="128" text-anchor="middle" font-size="20" font-weight="bold" fill="#333">₹</text>
  
  <!-- Coin 2 -->
  <circle cx="100" cy="105" r="18" fill="#FFE55C" stroke="#FFA500" stroke-width="2"/>
  <text x="100" y="112" text-anchor="middle" font-size="18" font-weight="bold" fill="#333">₹</text>
  
  <!-- Coin 3 -->
  <circle cx="125" cy="125" r="16" fill="#FFC107" stroke="#FFA500" stroke-width="2"/>
  <text x="125" y="131" text-anchor="middle" font-size="16" font-weight="bold" fill="#333">₹</text>
  
  <!-- Wallet -->
  <rect x="55" y="50" width="60" height="40" fill="#4A90E2" rx="4"/>
  <rect x="60" y="55" width="50" height="25" fill="#E8F4F8" rx="3"/>
  <line x1="60" y1="80" x2="110" y2="80" stroke="#4A90E2" stroke-width="1.5"/>
  
  <!-- Arrow Up -->
  <path d="M 140 75 L 160 55 L 180 75" stroke="#17A2B8" stroke-width="3" fill="none" stroke-linecap="round" stroke-linejoin="round"/>
  <line x1="160" y1="55" x2="160" y2="85" stroke="#17A2B8" stroke-width="3" stroke-linecap="round"/>
  
  <!-- Percentage -->
  <text x="155" y="150" font-size="24" font-weight="bold" fill="#17A2B8">↑</text>
</svg>''';
