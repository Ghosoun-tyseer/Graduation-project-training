
function updateClock() {
    const now = new Date();
    
    // تنسيق التاريخ والوقت
    const options = { 
        weekday: 'long', 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric',
       
    };
    
    // تحويله لنص بناءً على لغة الموقع (en-US أو ar-EG)
    const formattedDate = now.toLocaleDateString('en-US', options);
    
    // وضع النص في العنصر
    const clockElement = document.getElementById('live-clock');
    if (clockElement) {
        clockElement.innerText = formattedDate;
    }
}

// تشغيل الدالة فور تحميل الصفحة
updateClock();

// تحديث الساعة كل ثانية واحدة (1000 مللي ثانية)
setInterval(updateClock, 1000);

/* ── Modal ──────────────────────────────────────────────────── */
function openModal(html, maxWidth) {
  closeModal();
  var overlay = document.createElement('div');
  overlay.className = 'modal-overlay';
  overlay.id = 'smems-modal';
  overlay.innerHTML = '<div class="modal" style="max-width:' + (maxWidth || '520px') + '">' + html + '</div>';
  overlay.addEventListener('click', function(e) { if (e.target === overlay) closeModal(); });
  document.body.appendChild(overlay);
}

function closeModal() {
  var el = document.getElementById('smems-modal');
  if (el) el.remove();
}

document.addEventListener('keydown', function(e) {
  if (e.key === 'Escape') closeModal();
});

function showToast(msg, type) {
  var container = document.getElementById('toast-container');
  if (!container) {
    container = document.createElement('div');
    container.id = 'toast-container';
    container.className = 'toast-container';
    document.body.appendChild(container);
  }
  var toast = document.createElement('div');
  toast.className = 'toast toast-' + (type || 'info');
  toast.textContent = msg;
  container.appendChild(toast);
  setTimeout(function() {
    toast.style.opacity = '0';
    toast.style.transition = 'opacity .3s';
    setTimeout(function() { toast.remove(); }, 300);
  }, 3000);
}

function filterTable(inputId, tableId) {
  var q = document.getElementById(inputId).value.toLowerCase();
  document.querySelectorAll('#' + tableId + ' tbody tr').forEach(function(row) {
    row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
  });
}

function filterBySelect(selectId, tableId, colIndex) {
  var val = document.getElementById(selectId).value.toLowerCase();
  document.querySelectorAll('#' + tableId + ' tbody tr').forEach(function(row) {
    if (!val) { row.style.display = ''; return; }
    var cell = row.cells[colIndex];
    row.style.display = (cell && cell.textContent.toLowerCase().includes(val)) ? '' : 'none';
  });
}

function setReportTab(button, type) {
    // Remove active class from all tabs
    document.querySelectorAll(".report-tab").forEach(tab => {
        tab.classList.remove("active");
    });

    // Add active class to clicked tab
    button.classList.add("active");

    // Get cards
    const deviceCard = document.getElementById("device-card");
    const maintenanceCard = document.getElementById("maintenance-card");

    // Control visibility
    if (type === "device") {
        deviceCard.style.display = "block";
        maintenanceCard.style.display = "none";
    }
    else if (type === "maintenance") {
        deviceCard.style.display = "none";
        maintenanceCard.style.display = "block";
    }
    else if (type === "full") {
        deviceCard.style.display = "block";
        maintenanceCard.style.display = "block";
    }
}
// تشغيل الحالة الافتراضية عند تحميل الصفحة (اختياري)
// بما أن الـ Full Report هو النشط في الكود الأصلي، سيعمل تلقائياً

function setFormat(btn) {
  btn.closest('.format-toggle').querySelectorAll('.format-btn').forEach(function(b) {
    b.classList.remove('active');
  });
  btn.classList.add('active');
}

function markNotifRead(btn) {
  var item = btn.closest('.notif-item');
  item.classList.remove('unread');
 }

function deleteNotif(btn) {
  var item = btn.closest('.notif-item');
  item.style.opacity = '0';
  item.style.transition = 'opacity .3s';
  setTimeout(function() { item.remove(); }, 300);
 }

function markAllRead() {
  document.querySelectorAll('.notif-item.unread').forEach(function(el) {
    el.classList.remove('unread');
  });  showToast('All notifications marked as read', 'success');
}

function showDeviceInfo(btn) {
  var d = btn.dataset;
  var expired = d.warrantyExpiry && new Date(d.warrantyExpiry) < new Date();

  openModal(
    '<div class="modal-header">' +
      '<div>' +
        '<div class="modal-title">' + d.name + ' <span style="font-weight:400;color:var(--text-3);font-size:13px;">' + d.devId + '</span></div>' +
        '<div style="font-size:12px;color:var(--text-3);">' + (d.model || '') + '</div>' +
        '<div style="display:flex;gap:8px;margin-top:8px;">' +
          '<span class="badge b-' + statusClass(d.status) + '">' + d.status + '</span>' +
          '<span class="badge b-' + riskClass(d.risk) + '">'   + d.risk   + '</span>' +
        '</div>' +
      '</div>' +
      '<button class="modal-close" onclick="closeModal()">×</button>' +
    '</div>' +
    '<div class="modal-body">' +
      '<p class="info-section-title">🖥️ General Information</p>' +
      '<div class="info-grid-2">' +
        '<div class="info-item"><div class="lbl">Manufacturer</div><div class="val">' + (d.manufacturer || '—') + '</div></div>' +
        '<div class="info-item"><div class="lbl">Supplier</div><div class="val">'     + (d.supplier     || '—') + '</div></div>' +
        '<div class="info-item"><div class="lbl">Serial Number</div><div class="val">'+ (d.serial       || '—') + '</div></div>' +
        '<div class="info-item"><div class="lbl">Model</div><div class="val">'        + (d.model        || '—') + '</div></div>' +
      '</div>' +
      '<p class="info-section-title">📍 Location</p>' +
      '<div class="info-grid-2">' +
        '<div class="info-item"><div class="lbl">Department</div><div class="val">'     + (d.department || '—') + '</div></div>' +
        '<div class="info-item"><div class="lbl">Specific Location</div><div class="val">' + (d.location || '—') + '</div></div>' +
      '</div>' +
      '<p class="info-section-title">🛒 Purchase & Warranty</p>' +
      '<div class="info-grid-2">' +
        '<div class="info-item"><div class="lbl">Purchase Date</div><div class="val">'     + (d.purchaseDate  || '—') + '</div></div>' +
        '<div class="info-item"><div class="lbl">Warranty Expiry</div><div class="val ' + (expired ? 'val-expired' : '') + '">' + (d.warrantyExpiry || '—') + (expired ? '<br><small>Expired</small>' : '') + '</div></div>' +
        '<div class="info-item"><div class="lbl">Expected Lifespan</div><div class="val">' + (d.lifespan  || '—') + '</div></div>' +
        '<div class="info-item"><div class="lbl">Failure Count</div><div class="val">'    + (d.failures  || '0') + ' failure(s)</div></div>' +
      '</div>' +
      (d.nextMaint ? '<div class="next-maint-box">📅 <div><div style="font-size:13px;font-weight:600;color:var(--info);">Next Preventive Maintenance</div><div style="font-size:12px;color:var(--info);">Scheduled for ' + d.nextMaint + '</div></div></div>' : '') +
      (d.accessories ? '<p class="info-section-title" style="margin-top:12px;">🔧 Accessories & Parts</p><div class="tag-list">' + d.accessories.split(',').map(function(a) { return '<span class="tag">' + a.trim() + '</span>'; }).join('') + '</div>' : '') +
      (d.lastMaintType ? '<p class="info-section-title" style="margin-top:12px;">Last Maintenance</p><div class="info-item"><div style="font-weight:600;font-size:13px;">' + d.lastMaintType + '</div><div class="lbl">' + (d.lastMaintDate || '') + '</div><div style="font-size:13px;margin-top:4px;">' + (d.lastMaintDetail || '') + '</div></div>' : '') +
    '</div>' +
    '<div class="modal-footer"><button class="btn btn-outline" onclick="closeModal()">Close</button></div>'
  , '520px');
}


function showMaintHistory(btn) {
  var d = btn.dataset;
  openModal(
    '<div class="modal-header">' +
      '<div>' +
        '<div class="modal-title">' + d.name + ' <span style="font-weight:400;color:var(--text-3);font-size:13px;">' + d.devId + '</span></div>' +
        '<div style="display:flex;gap:8px;margin-top:8px;">' +
          '<span class="badge b-' + statusClass(d.status) + '">' + d.status + '</span>' +
          '<span class="badge b-' + riskClass(d.risk)   + '">' + d.risk   + '</span>' +
        '</div>' +
      '</div>' +
      '<button class="modal-close" onclick="closeModal()">×</button>' +
    '</div>' +
    '<div class="modal-body">' +
      (d.historyHtml || '<p style="text-align:center;padding:24px;color:var(--text-3);">No maintenance history</p>') +
    '</div>' +
    '<div class="modal-footer"><button class="btn btn-outline" onclick="closeModal()">Close</button></div>'
  , '480px');
}


function showRequestDetail(btn) {
  var d = btn.dataset;
  var altHtml = d.alt === 'true'
    ? '<div class="alert alert-info">✓ Alternative device is available in the department</div>'
    : '<div class="alert alert-danger">⚠ This device has NO replacement. Urgent action required.</div>';

  openModal(
    '<div class="modal-header">' +
      '<div>' +
        '<div class="modal-title" style="color:var(--primary);">Maintenance Request Details</div>' +
        '<div class="modal-subtitle">Submitted by ' + (d.dept || '') + ' Department · ' + (d.date || '') + '</div>' +
      '</div>' +
      '<button class="modal-close" onclick="closeModal()">×</button>' +
    '</div>' +
    '<div class="modal-body">' +
      '<div class="form-section">' +
        '<div class="form-section-title">● Asset Information</div>' +
        '<div class="form-row" style="margin-bottom:10px;">' +
          '<div><div class="form-label">Device Name</div><div class="req-field">' + (d.deviceName || '—') + '</div></div>' +
          '<div><div class="form-label">Model</div><div class="req-field">'       + (d.model      || '—') + '</div></div>' +
        '</div>' +
        '<div class="form-row">' +
          '<div><div class="form-label">Serial Number</div><div class="req-field">' + (d.serial || '—') + '</div></div>' +
          '<div><div class="form-label">Asset ID</div><div class="req-field">'      + (d.devId  || '—') + '</div></div>' +
        '</div>' +
      '</div>' +
      '<div class="form-section">' +
        '<div class="form-section-title">🔧 Maintenance Details</div>' +
        '<div class="form-group"><div class="form-label">Problem Type</div><div class="req-field">' + (d.issue || '—') + '</div></div>' +
        '<div><div class="form-label">Description</div><div class="req-field" style="min-height:65px;">' + (d.desc || '—') + '</div></div>' +
      '</div>' +
      '<div class="form-section" style="margin-bottom:0;">' +
        '<div class="form-section-title">🔵 Service Continuity</div>' + altHtml +
      '</div>' +
      (d.engNotes ? '<div class="form-section" style="margin-top:12px;margin-bottom:0;"><div class="form-section-title">Engineer Notes</div><div class="req-field">' + d.engNotes + '</div></div>' : '') +
    '</div>' +
    '<div class="modal-footer"><button class="btn btn-primary" onclick="closeModal()">Close</button></div>'
  , '580px');
}


function showEditUser(btn) {
  var d = btn.dataset;
  openModal(
    '<div class="modal-header"><div class="modal-title">Edit User</div><button class="modal-close" onclick="closeModal()">×</button></div>' +
    '<div class="modal-body">' +
      '<div class="form-row">' +
        '<div class="form-group"><label class="form-label">Full Name</label><input class="form-control" id="eu-name"  value="' + (d.name     || '') + '"></div>' +
        '<div class="form-group"><label class="form-label">Username</label><input class="form-control"  id="eu-user"  value="' + (d.username || '') + '"></div>' +
      '</div>' +
      '<div class="form-row">' +
        '<div class="form-group"><label class="form-label">Email</label><input class="form-control" type="email" id="eu-email" value="' + (d.email || '') + '"></div>' +
        '<div class="form-group"><label class="form-label">Phone</label><input class="form-control" id="eu-phone" value="' + (d.phone || '') + '"></div>' +
      '</div>' +
      '<div class="form-row">' +
        '<div class="form-group"><label class="form-label">Role</label>' +
          '<select class="form-control" id="eu-role">' +
            '<option value="admin"    ' + (d.role === 'admin'    ? 'selected' : '') + '>Administrator</option>' +
            '<option value="engineer" ' + (d.role === 'engineer' ? 'selected' : '') + '>Engineer</option>' +
            '<option value="staff"    ' + (d.role === 'staff'    ? 'selected' : '') + '>Medical Staff</option>' +
          '</select>' +
        '</div>' +
        '<div class="form-group"><label class="form-label">Department</label><input class="form-control" id="eu-dept" value="' + (d.dept || '') + '"></div>' +
      '</div>' +
      '<div class="form-group"><label class="form-label">Position</label><input class="form-control" id="eu-pos" value="' + (d.pos || '') + '"></div>' +
    '</div>' +
    '<div class="modal-footer">' +
      '<button class="btn btn-outline" onclick="closeModal()">Cancel</button>' +
      /* TODO: غيِّر onclick ليُرسل fetch PUT /api/users/{id} */
      '<button class="btn btn-primary" onclick="closeModal();showToast(\'User updated\',\'success\')">Save Changes</button>' +
    '</div>'
  , '500px');
}


function confirmDeleteUser(name, userId) {
  openModal(
    '<div class="modal-header"><div class="modal-title">Delete User</div><button class="modal-close" onclick="closeModal()">×</button></div>' +
    '<div class="modal-body"><div class="alert alert-danger">⚠ Are you sure you want to delete <strong>' + name + '</strong>? This cannot be undone.</div></div>' +
    '<div class="modal-footer">' +
      '<button class="btn btn-outline" onclick="closeModal()">Cancel</button>' +
      /* TODO: غيِّر onclick ليُرسل fetch DELETE /api/users/{userId} */
      '<button class="btn btn-danger" onclick="closeModal();showToast(\'User deleted\',\'success\')">Delete</button>' +
    '</div>'
  , '380px');
}

function showRequestForm(devId, devName) {
  openModal(
    '<div class="modal-header"><div class="modal-title">Request Maintenance</div><button class="modal-close" onclick="closeModal()">×</button></div>' +
    '<div class="modal-body">' +
      '<div class="form-group">' +
        '<label class="form-label req">Device</label>' +
        (devId
          ? '<div class="req-field">' + devName + '</div><input type="hidden" name="device_id" value="' + devId + '">'
          : '<select class="form-control" name="device_id"><option value="">Select a device...</option></select>'
            ) +
      '</div>' +
      '<div class="form-group">' +
        '<label class="form-label req">Issue Type</label>' +
        '<select class="form-control" name="issue_type">' +
          '<option value="">Select issue type...</option>' +
          '<option>Display malfunction</option>' +
          '<option>Alarm system fault</option>' +
          '<option>Complete failure</option>' +
          '<option>Software Error / Sudden Failure</option>' +
          '<option>Image quality degradation</option>' +
          '<option>Calibration issue</option>' +
          '<option>Power supply problem</option>' +
          '<option>Mechanical failure</option>' +
          '<option>Other</option>' +
        '</select>' +
      '</div>' +
      '<div class="form-group">' +
        '<label class="form-label req">Problem Description</label>' +
        '<textarea class="form-control" name="description" rows="4" placeholder="Describe the issue in detail..."></textarea>' +
        '<div class="form-hint">Be as specific as possible to help the engineer diagnose the problem</div>' +
      '</div>' +
      '<div class="form-group">' +
        '<label class="form-label">Upload Images (Optional)</label>' +
        '<div class="upload-zone" onclick="document.getElementById(\'req-file\').click()">' +
          '<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="16 16 12 12 8 16"/><line x1="12" y1="12" x2="12" y2="21"/><path d="M20.39 18.39A5 5 0 0 0 18 9h-1.26A8 8 0 1 0 3 16.3"/></svg>' +
          '<div style="font-size:13px;color:var(--text-2);">Click to upload or drag and drop</div>' +
          '<div style="font-size:11px;color:var(--text-3);">PNG, JPG</div>' +
        '</div>' +
        '<input type="file" id="req-file" name="photos" multiple accept="image/*" style="display:none;">' +
      '</div>' +
      '<label class="check-wrap">' +
        '<input type="checkbox" name="alternative_available">' +
        '<div class="check-label">' +
          '<strong>Alternative device available</strong>' +
          '<span>Check this if there\'s a backup device available in the department</span>' +
        '</div>' +
      '</label>' +
    '</div>' +
    '<div class="modal-footer">' +
      '<button class="btn btn-outline" onclick="closeModal()">Cancel</button>' +
       '<button class="btn btn-primary" onclick="closeModal();showToast(\'Request submitted successfully\',\'success\')">Submit Request</button>' +
    '</div>'
  , '480px');
}

function showCompleteModal(reqId, devName) {
  openModal(
    '<div class="modal-header">' +
      '<div><div class="modal-title">Complete Maintenance</div>' +
        (devName ? '<div class="modal-subtitle">' + devName + '</div>' : '') +
      '</div>' +
      '<button class="modal-close" onclick="closeModal()">×</button>' +
    '</div>' +
    '<div class="modal-body">' +
      '<div class="form-group">' +
        '<label class="form-label req">Engineer Notes / Repair Description</label>' +
        '<textarea class="form-control" id="cm-notes" name="engineer_notes" rows="5" placeholder="Describe the problem found, parts replaced, calibrations performed..."></textarea>' +
      '</div>' +
      '<div class="form-group">' +
        '<label class="form-label">Device Status After Repair</label>' +
        '<select class="form-control" id="cm-status" name="device_status">' +
          '<option value="Operational">Operational — Fully repaired</option>' +
          '<option value="Maintenance Needed">Maintenance Needed — Needs follow-up</option>' +
          '<option value="Out of Service">Out of Service — Awaiting parts</option>' +
        '</select>' +
      '</div>' +
    '</div>' +
    '<div class="modal-footer">' +
      '<button class="btn btn-outline" onclick="closeModal()">Cancel</button>' +
        '<button class="btn btn-success" onclick="closeModal();showToast(\'Maintenance completed!\',\'success\')">✓ Mark as Completed</button>' +
    '</div>'
  , '460px');
}


function showAddDeviceModal() {
  var accs = [];
  openModal(
    '<div class="modal-header"><div class="modal-title">Add New Device</div><button class="modal-close" onclick="closeModal()">×</button></div>' +
    '<div class="modal-body">' +
      '<div class="form-section">' +
        '<div class="form-section-title">General Information</div>' +
        '<div class="form-row">' +
          '<div class="form-group"><label class="form-label req">Device Name</label><input class="form-control" name="name" id="ad-name" placeholder="Device name"></div>' +
          '<div class="form-group"><label class="form-label req">Model</label><input class="form-control" name="model" id="ad-model" placeholder="Model code"></div>' +
        '</div>' +
        '<div class="form-row">' +
          '<div class="form-group"><label class="form-label req">Manufacturer</label><input class="form-control" name="manufacturer" placeholder="Manufacturer"></div>' +
          '<div class="form-group"><label class="form-label">Supplier</label><input class="form-control" name="supplier" placeholder="Supplier"></div>' +
        '</div>' +
        '<div class="form-row">' +
          '<div class="form-group"><label class="form-label req">Serial Number</label><input class="form-control" name="serial_number" placeholder="Serial number"></div>' +
          '<div class="form-group"><label class="form-label req">Risk Level</label>' +
            '<select class="form-control" name="risk_level"><option value="">Select...</option><option>Low Risk</option><option>Medium Risk</option><option>High Risk</option><option>Critical Risk</option></select>' +
          '</div>' +
        '</div>' +
      '</div>' +
      '<div class="form-section">' +
        '<div class="form-section-title">Location</div>' +
        '<div class="form-row">' +
          '<div class="form-group"><label class="form-label req">Department</label>' +
            '<select class="form-control" name="department"><option value="">Select...</option><option>ICU</option><option>Radiology</option><option>Emergency Room</option><option>Cardiology</option><option>Surgery</option><option>Inventory</option></select>' +
          '</div>' +
          '<div class="form-group"><label class="form-label">Specific Location</label><input class="form-control" name="specific_location" placeholder="Room / Bed"></div>' +
        '</div>' +
      '</div>' +
      '<div class="form-section">' +
        '<div class="form-section-title">Purchase & Warranty</div>' +
        '<div class="form-row">' +
          '<div class="form-group"><label class="form-label">Purchase Date</label><input class="form-control" type="date" name="purchase_date"></div>' +
          '<div class="form-group"><label class="form-label">Warranty Expiry</label><input class="form-control" type="date" name="warranty_expiry"></div>' +
        '</div>' +
        '<div class="form-row">' +
          '<div class="form-group"><label class="form-label">Expected Lifespan</label><input class="form-control" name="expected_lifespan" placeholder="e.g. 10 years"></div>' +
          '<div class="form-group"><label class="form-label">Next Preventive Maint.</label><input class="form-control" type="date" name="next_preventive_maintenance"></div>' +
        '</div>' +
      '</div>' +
      '<div class="form-section" style="margin-bottom:0;">' +
        '<div class="form-section-title">Accessories & Parts</div>' +
        '<input class="form-control" id="ad-acc-in" placeholder="Type and press Enter">' +
        '<div class="tag-list" id="ad-acc-list"></div>' +
        '<input type="hidden" name="accessories" id="ad-acc-val" value="">' +
      '</div>' +
    '</div>' +
    '<div class="modal-footer">' +
      '<button class="btn btn-outline" onclick="closeModal()">Cancel</button>' +
        '<button class="btn btn-primary" onclick="closeModal();showToast(\'Device added! Reload to see it.\',\'success\')">Save Device</button>' +
    '</div>'
  , '580px');

  document.getElementById('ad-acc-in').addEventListener('keydown', function(e) {
    if (e.key === 'Enter' && this.value.trim()) {
      accs.push(this.value.trim());
      document.getElementById('ad-acc-list').innerHTML = accs.map(function(a) { return '<span class="tag">' + a + '</span>'; }).join('');
      document.getElementById('ad-acc-val').value = accs.join(',');
      this.value = '';
    }
  });
}
function statusClass(s) {
  s = (s || '').toLowerCase().replace(/ /g, '-');
  if (s.includes('operational')) return 'operational';
  if (s.includes('needed'))      return 'needed';
  if (s.includes('under'))       return 'under';
  if (s.includes('out'))         return 'out';
  if (s.includes('progress'))    return 'inprogress';
  if (s.includes('pending'))     return 'pending';
  if (s.includes('completed'))   return 'completed';
  return '';
}
function riskClass(r) {
  r = (r || '').toLowerCase();
  if (r.includes('critical')) return 'critical';
  if (r.includes('high'))     return 'high';
  if (r.includes('medium'))   return 'medium';
  if (r.includes('low'))      return 'low';
  return '';
}


function renderSidebar() {

  const role = localStorage.getItem('smems_role');
  const sidebar = document.getElementById('sidebar-nav');

  if (!sidebar) return;

  let links = '';

  // ADMIN
  if (role === 'admin') {

    links = `
      <a href="admin-dashboard.html" class="nav-link">Dashboard</a>
      <a href="devices.html" class="nav-link">Devices</a>
      <a href="maintenance.html" class="nav-link">Maintenance</a>
      <a href="reports.html" class="nav-link">Reports</a>
      <a href="users.html" class="nav-link">Users</a>
      <a href="notifications.html" class="nav-link">Notifications</a>
      <a href="profile.html" class="nav-link">Profile</a>
      <a href="edit-profile.html" class="nav-link">Edit Profile</a>
    `;
  }

  // STAFF
  else if (role === 'staff') {

    links = `
      <a href="staff-dashboard.html" class="nav-link">Dashboard</a>
      <a href="my-requests.html" class="nav-link">My Requests</a>
      <a href="notifications.html" class="nav-link">Notifications</a>
      <a href="devices.html" class="nav-link">Devices</a>
      <a href="profile.html" class="nav-link">Profile</a>
      <a href="edit-profile.html" class="nav-link">Edit Profile</a>
    `;
  }

  // ENGINEER
  else if (role === 'engineer') {

    links = `
      <a href="engineer-dashboard.html" class="nav-link">Dashboard</a>
      <a href="maintenance.html" class="nav-link">Maintenance Requests</a>
      <a href="devices.html" class="nav-link">Devices</a>
      <a href="notifications.html" class="nav-link">Notifications</a>
      <a href="profile.html" class="nav-link">Profile</a>
      <a href="edit-profile.html" class="nav-link">Edit Profile</a>
    `;
  }

  sidebar.innerHTML = links;
}

renderSidebar();