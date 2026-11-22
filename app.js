document.addEventListener('DOMContentLoaded', () => {
    // اگر صفحه اول باز باشد
    if (document.getElementById('teamsGrid')) {
        initSelectionPage();
    }
    // اگر صفحه داشبورد باز باشد
    if (document.getElementById('leagueList')) {
        initDashboardPage();
    }
});

// ================= منطق صفحه ۱ =================
function initSelectionPage() {
    const grid = document.getElementById('teamsGrid');
    const confirmBtn = document.getElementById('confirmBtn');
    let selectedTeamId = null;

    teams.forEach(team => {
        const card = document.createElement('div');
        card.className = 'team-card';
        card.dataset.id = team.id;
        card.innerHTML = `
            <div class="team-logo">${team.logo}</div>
            <div class="team-name-bar"><span class="team-name">${team.name}</span></div>
        `;

        card.addEventListener('click', () => {
            document.querySelectorAll('.team-card').forEach(c => c.classList.remove('selected'));
            card.classList.add('selected');
            selectedTeamId = team.id;
            confirmBtn.disabled = false;
        });

        grid.appendChild(card);
    });

    confirmBtn.addEventListener('click', () => {
        if (selectedTeamId) {
            localStorage.setItem('selectedTeam', selectedTeamId);
            window.location.href = 'dashboard.html';
        }
    });
}

// ================= منطق صفحه ۲ =================
function initDashboardPage() {
    const selectedTeamId = localStorage.getItem('selectedTeam') || 'realmadrid';
    const userTeam = teams.find(t => t.id === selectedTeamId) || teams[13];

    // 1. ست کردن لوگو و اسم تیم در نوار بالا
    const dashLogo = document.getElementById('dashClubLogo');
    dashLogo.innerHTML = userTeam.logo;
    
    // بزرگ کردن لوگو در نوار بالا
    const svgInTopBar = dashLogo.querySelector('svg');
    if(svgInTopBar) {
        svgInTopBar.setAttribute('width', '100%');
        svgInTopBar.setAttribute('height', '100%');
    }

    const clubTitle = document.querySelector('.club-title');
    clubTitle.textContent = userTeam.name; // اسم تیم واقعی رو می‌نویسیم

    // 2. لول 1
    document.getElementById('dashLevel').textContent = 'Lv. 1';

    // 3. ساخت جدول لیگ
    const leagueList = document.getElementById('leagueList');
    // 4 تیم ثابت + تیم کاربر (که رتبه 29 رو با رنگ سبز می‌گیره)
    const leagueData = [
        { name: 'رئال مادرید', id: 'realmadrid', pts: 32, rank: 1 },
        { name: 'بارسلونا', id: 'barcelona', pts: 31, rank: 2 },
        { name: userTeam.name, id: userTeam.id, pts: 33, rank: 29, active: true }, // تیم کاربر
        { name: 'اتلتیکو مادرید', id: 'atletico', pts: 28, rank: 4 },
        { name: 'سویا', id: 'sevilla', pts: 26, rank: 5 }
    ];

    leagueData.forEach(row => {
        const rowEl = document.createElement('div');
        rowEl.className = `league-row ${row.active ? 'active' : ''}`;
        
        // پیدا کردن لوگو
        let rowLogo = '';
        if (row.id === 'sevilla') {
            // لوگوی سویا (چون توی لیست ۱۵ تایی نبود)
            rowLogo = `<svg viewBox="0 0 100 100"><path d="M50 10 L20 30 V50 C20 70, 35 90, 50 95 C65 90, 80 70, 80 50 V30 Z" fill="#D40000" stroke="#fff" stroke-width="4"/><text x="50" y="60" font-size="20" fill="#fff" text-anchor="middle" font-weight="bold">S</text></svg>`;
        } else {
            const teamObj = teams.find(t => t.id === row.id);
            rowLogo = teamObj ? teamObj.logo : '';
        }

        rowEl.innerHTML = `
            <div class="team-col">${rowLogo} <span>${row.name}</span></div>
            <span>${row.rank}</span>
            <span>${row.pts}</span>
        `;
        leagueList.appendChild(rowEl);
    });
}
