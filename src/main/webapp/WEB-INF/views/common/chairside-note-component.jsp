<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- Chairside Note Floating Button -->
<div class="chairside-note-fab" onclick="openChairsideNoteModal()" id="chairsideNoteFab">
    <i class="fas fa-sticky-note"></i>
    <c:if test="${not empty patient.chairsideNote}">
        <div class="fab-indicator"></div>
    </c:if>
    <span class="fab-tooltip">Hand Over Note</span>
</div>

<!-- Chairside Note Modal -->
<div id="chairsideNoteModal" class="chairside-note-modal">
    <div class="chairside-note-modal-content">
        <div class="chairside-note-modal-header">
            <h3><i class="fas fa-sticky-note"></i> Hand Over Note</h3>
            <span class="chairside-note-modal-close" onclick="closeChairsideNoteModal()">&times;</span>
        </div>
        <div class="chairside-note-modal-body">
            <div class="form-group">
                <label for="chairsideNoteText">Add New Note</label>
                <textarea id="chairsideNoteText" rows="4" class="form-control" 
                          placeholder="Enter new hand over note..."></textarea>

            </div>
            
            <c:if test="${not empty patient.chairsideNote}">
                <div class="form-group" style="margin-top: 20px;">
                    <label>Hand Over Notes History</label>
                    <div class="notes-history" style="background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 8px; padding: 15px; max-height: 300px; overflow-y: auto; font-family: 'Courier New', monospace; font-size: 12px; white-space: pre-wrap; line-height: 1.4; color: #495057;">
                        ${patient.chairsideNote}
                    </div>
                </div>
            </c:if>
        </div>
        <div class="chairside-note-modal-footer">
            <div class="footer-left">
                <button type="button" class="btn btn-outline-danger" onclick="clearChairsideNote()">
                    <i class="fas fa-trash"></i> Clear
                </button>
            </div>
            <div class="footer-right">
                <button type="button" class="btn btn-outline-secondary" onclick="closeChairsideNoteModal()">
                    <i class="fas fa-times"></i> Cancel
                </button>
                <button type="button" class="btn btn-primary" onclick="saveChairsideNote()">
                    <i class="fas fa-save"></i> Save Note
                </button>
            </div>
        </div>
    </div>
</div> 