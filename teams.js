const teams = [
    { 
        id: 'mancity', name: 'Manchester City', color: '#6CABDD',
        logo: `<svg viewBox="0 0 100 100"><circle cx="50" cy="50" r="45" fill="#f0f0f0" stroke="#6CABDD" stroke-width="6"/><path d="M30 60h40v15H30z" fill="#00285e"/><path d="M40 60l10-15 10 15z" fill="#6CABDD"/><circle cx="50" cy="40" r="8" fill="#00285e"/></svg>`
    },
    { 
        id: 'liverpool', name: 'Liverpool', color: '#C8102E',
        logo: `<svg viewBox="0 0 100 100"><path d="M50 15 C45 30, 30 40, 30 60 C30 75, 40 85, 50 90 C60 85, 70 75, 70 60 C70 40, 55 30, 50 15 Z" fill="#C8102E"/><path d="M45 40 L50 25 L55 40 Z" fill="#C8102E"/><rect x="35" y="55" width="30" height="20" fill="none" stroke="#C8102E" stroke-width="3"/><text x="50" y="70" font-size="12" fill="#C8102E" text-anchor="middle" font-weight="bold">L.F.C</text></svg>`
    },
    { 
        id: 'arsenal', name: 'Arsenal', color: '#EF0107',
        logo: `<svg viewBox="0 0 100 100"><path d="M50 10 L20 30 V60 C20 80, 35 90, 50 95 C65 90, 80 80, 80 60 V30 Z" fill="#EF0107" stroke="#023474" stroke-width="3"/><path d="M40 50 L50 30 L60 50 Z" fill="#fff"/><rect x="35" y="55" width="30" height="20" fill="#023474"/><text x="50" y="70" font-size="12" fill="#fff" text-anchor="middle" font-weight="bold">Arsenal</text></svg>`
    },
    { 
        id: 'manutd', name: 'Manchester United', color: '#DA291C',
        logo: `<svg viewBox="0 0 100 100"><path d="M50 10 L25 25 V50 C25 75, 40 90, 50 95 C60 90, 75 75, 75 50 V25 Z" fill="#DA291C" stroke="#FBE122" stroke-width="3"/><circle cx="50" cy="40" r="12" fill="#FBE122"/><rect x="40" y="55" width="20" height="25" fill="#FBE122"/><path d="M50 15 L45 25 L55 25 Z" fill="#fff"/></svg>`
    },
    { 
        id: 'chelsea', name: 'Chelsea', color: '#034694',
        logo: `<svg viewBox="0 0 100 100"><circle cx="50" cy="50" r="40" fill="#034694" stroke="#fff" stroke-width="4"/><circle cx="50" cy="40" r="15" fill="#fff"/><rect x="35" y="60" width="30" height="15" fill="#fff"/><text x="50" y="72" font-size="10" fill="#034694" text-anchor="middle" font-weight="bold">CFC</text></svg>`
    },
    { 
        id: 'tottenham', name: 'Tottenham Hotspur', color: '#132257',
        logo: `<svg viewBox="0 0 100 100"><ellipse cx="50" cy="70" rx="20" ry="15" fill="#fff" stroke="#132257" stroke-width="3"/><path d="M50 10 L45 50 L55 50 Z" fill="#fff" stroke="#132257" stroke-width="2"/><circle cx="50" cy="75" r="8" fill="#132257"/></svg>`
    },
    { 
        id: 'newcastle', name: 'Newcastle United', color: '#241F20',
        logo: `<svg viewBox="0 0 100 100"><path d="M50 10 L30 30 V50 C30 70, 40 80, 50 90 C60 80, 70 70, 70 50 V30 Z" fill="#241F20" stroke="#fff" stroke-width="3"/><rect x="40" y="35" width="20" height="10" fill="#fff"/><rect x="40" y="50" width="20" height="10" fill="#fff"/></svg>`
    },
    { 
        id: 'astonvilla', name: 'Aston Villa', color: '#95BFE5',
        logo: `<svg viewBox="0 0 100 100"><rect x="20" y="20" width="60" height="60" fill="#670E36" stroke="#95BFE5" stroke-width="4"/><path d="M30 70 L50 30 L70 70 Z" fill="#95BFE5"/><text x="50" y="65" font-size="12" fill="#670E36" text-anchor="middle" font-weight="bold">AVFC</text></svg>`
    },
    { 
        id: 'westham', name: 'West Ham United', color: '#7A263A',
        logo: `<svg viewBox="0 0 100 100"><path d="M50 10 L20 30 V50 C20 75, 35 90, 50 95 C65 90, 80 75, 80 50 V30 Z" fill="#7A263A" stroke="#1BB1E7" stroke-width="4"/><path d="M35 50 L50 35 L65 50" fill="none" stroke="#fff" stroke-width="4"/><circle cx="50" cy="70" r="10" fill="#1BB1E7"/></svg>`
    },
    { 
        id: 'everton', name: 'Everton', color: '#003399',
        logo: `<svg viewBox="0 0 100 100"><path d="M50 10 L20 30 V60 C20 80, 35 90, 50 95 C65 90, 80 80, 80 60 V30 Z" fill="#003399" stroke="#fff" stroke-width="4"/><circle cx="50" cy="45" r="15" fill="#fff"/><rect x="35" y="65" width="30" height="15" fill="#fff"/></svg>`
    },
    { 
        id: 'brighton', name: 'Brighton & Hove Albion', color: '#0057B8',
        logo: `<svg viewBox="0 0 100 100"><circle cx="50" cy="50" r="40" fill="#fff" stroke="#0057B8" stroke-width="6"/><path d="M30 50 L50 30 L70 50" fill="none" stroke="#0057B8" stroke-width="6"/><text x="50" y="75" font-size="10" fill="#0057B8" text-anchor="middle" font-weight="bold">BHAFC</text></svg>`
    },
    { 
        id: 'forest', name: 'Nottingham Forest', color: '#DD0000',
        logo: `<svg viewBox="0 0 100 100"><rect x="20" y="20" width="60" height="60" fill="#DD0000"/><path d="M50 30 L30 50 V70 H70 V50 Z" fill="#fff"/><rect x="40" y="70" width="20" height="20" fill="#DD0000"/></svg>`
    },
    { 
        id: 'barcelona', name: 'Barcelona', color: '#A50044',
        logo: `<svg viewBox="0 0 100 100"><rect x="20" y="15" width="60" height="70" fill="#004D98" stroke="#EDBB00" stroke-width="4"/><path d="M20 35 H80 M20 55 H80" stroke="#A50044" stroke-width="15"/><path d="M50 15 V85" stroke="#EDBB00" stroke-width="10"/><circle cx="50" cy="50" r="8" fill="#fff"/></svg>`
    },
    { 
        id: 'realmadrid', name: 'Real Madrid', color: '#FFFFFF',
        logo: `<svg viewBox="0 0 100 100"><circle cx="50" cy="55" r="30" fill="#fff" stroke="#00529F" stroke-width="4"/><path d="M35 25 L40 10 L50 20 L60 10 L65 25" fill="#FEBE10" stroke="#FEBE10" stroke-width="2"/><text x="50" y="65" font-size="20" fill="#00529F" text-anchor="middle" font-weight="bold">RM</text><circle cx="50" cy="80" r="5" fill="#FEBE10"/></svg>`
    },
    { 
        id: 'atletico', name: 'Atlético Madrid', color: '#CB3524',
        logo: `<svg viewBox="0 0 100 100"><path d="M50 10 L20 30 V60 C20 80, 35 90, 50 95 C65 90, 80 80, 80 60 V30 Z" fill="#CB3524" stroke="#fff" stroke-width="4"/><path d="M20 40 H80 M20 60 H80" stroke="#fff" stroke-width="8"/><circle cx="50" cy="30" r="10" fill="#fff"/></svg>`
    }
];
