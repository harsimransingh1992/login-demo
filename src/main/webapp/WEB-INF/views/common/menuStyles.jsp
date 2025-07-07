<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    /* Sidebar Menu Styles */
    .sidebar-menu {
        width: 280px;
        background: rgba(255, 255, 255, 0.1);
        backdrop-filter: blur(20px);
        -webkit-backdrop-filter: blur(20px);
        border-right: 1px solid rgba(255, 255, 255, 0.2);
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        z-index: 1000;
        overflow-y: auto;
        transition: transform 0.3s ease;
        display: flex;
        flex-direction: column;
    }
    
    .sidebar-menu.active {
        transform: translateX(0);
    }
    
    .logo {
        padding: 25px 20px;
        display: flex;
        align-items: center;
        gap: 12px;
        background: rgba(52, 152, 219, 0.1);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        margin-bottom: 0;
        position: relative;
    }
    
    .logo::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(135deg, rgba(52, 152, 219, 0.2), rgba(41, 128, 185, 0.1));
        z-index: -1;
    }
    
    .logo img {
        width: 45px;
        height: 45px;
        filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
    }
    
    .logo h1 {
        margin: 0;
        font-size: 1.6rem;
        color: #2c3e50;
        font-weight: 700;
        letter-spacing: 0.5px;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
    }
    
    /* User Info Styles */
    .user-info {
        padding: 20px;
        background: rgba(255, 255, 255, 0.05);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        margin-bottom: 0;
        text-align: center;
        position: relative;
    }
    
    .user-info::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(135deg, rgba(52, 152, 219, 0.05), rgba(41, 128, 185, 0.02));
        z-index: -1;
    }
    
    .user-name {
        margin: 0;
        font-size: 1.1rem;
        font-weight: 600;
        color: #2c3e50;
        line-height: 1.3;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
    }
    
    .action-card {
        display: flex;
        align-items: center;
        padding: 16px 20px;
        text-decoration: none;
        color: #2c3e50;
        transition: all 0.3s ease;
        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        position: relative;
        overflow: hidden;
        background: transparent;
        padding-left: 23px;
    }
    
    .action-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(135deg, rgba(52, 152, 219, 0.1), rgba(41, 128, 185, 0.05));
        opacity: 0;
        transition: opacity 0.3s ease;
        z-index: 0;
    }
    
    .action-card::after {
        content: '';
        position: absolute;
        left: 0;
        top: 0;
        bottom: 0;
        width: 3px;
        background: linear-gradient(135deg, #3498db, #2980b9);
        opacity: 0;
        transition: opacity 0.3s ease;
        z-index: 1;
    }
    
    .action-card:hover {
        color: #3498db;
        background: rgba(52, 152, 219, 0.05);
    }
    
    .action-card:hover::before {
        opacity: 1;
    }
    
    .action-card:hover::after {
        opacity: 1;
    }
    
    .action-card:hover i {
        transform: scale(1.15);
        color: #3498db;
        text-shadow: 0 2px 4px rgba(52, 152, 219, 0.3);
    }
    
    .action-card:hover .card-text h3 {
        color: #3498db;
        text-shadow: 0 1px 2px rgba(52, 152, 219, 0.2);
        transform: translateX(3px);
    }
    
    .action-card:hover .card-text p {
        color: #3498db;
        transform: translateX(3px);
    }
    
    .action-card i {
        font-size: 1.3rem;
        width: 35px;
        text-align: center;
        margin-right: 15px;
        transition: all 0.3s ease;
        color: #7f8c8d;
        z-index: 2;
        position: relative;
    }
    
    .card-text {
        flex: 1;
        z-index: 2;
        position: relative;
    }
    
    .card-text h3 {
        margin: 0;
        font-size: 1rem;
        font-weight: 600;
        transition: all 0.3s ease;
        color: #2c3e50;
        transform: translateX(0);
    }
    
    .card-text p {
        margin: 4px 0 0 0;
        font-size: 0.85rem;
        color: #7f8c8d;
        transition: all 0.3s ease;
        font-weight: 400;
        transform: translateX(0);
    }
    
    .footer {
        margin-top: auto;
        padding: 25px 20px;
        text-align: center;
        background: rgba(255, 255, 255, 0.05);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        border-top: 1px solid rgba(255, 255, 255, 0.1);
        position: relative;
    }
    
    .footer::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(135deg, rgba(52, 152, 219, 0.05), rgba(41, 128, 185, 0.02));
        z-index: -1;
    }
    
    .copyright {
        font-size: 0.8rem;
        color: #7f8c8d;
        margin: 0 0 8px;
        font-weight: 400;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
    }
    
    .powered-by {
        font-size: 0.8rem;
        color: #3498db;
        font-weight: 600;
        text-shadow: 0 1px 2px rgba(52, 152, 219, 0.2);
    }
    
    .navtech {
        color: #2c3e50;
        font-weight: 700;
        text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
    }
    
    /* Mobile Menu Styles */
    .menu-toggle {
        display: none;
        position: fixed;
        top: 20px;
        left: 20px;
        z-index: 1001;
        background: rgba(52, 152, 219, 0.9);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 12px;
        padding: 12px;
        box-shadow: 0 8px 32px rgba(52, 152, 219, 0.3);
        cursor: pointer;
        color: white;
        transition: all 0.3s ease;
    }
    
    .menu-toggle:hover {
        transform: translateY(-2px);
        box-shadow: 0 12px 40px rgba(52, 152, 219, 0.4);
        background: rgba(52, 152, 219, 1);
    }
    
    .overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.3);
        z-index: 999;
        backdrop-filter: blur(5px);
        -webkit-backdrop-filter: blur(5px);
    }
    
    .overlay.active {
        display: block;
    }
    
    /* Responsive Styles */
    @media (max-width: 768px) {
        .sidebar-menu {
            transform: translateX(-100%);
        }
        
        .menu-toggle {
            display: block;
        }
        
        .overlay.active {
            display: block;
        }
    }
    
    /* Scrollbar Styling */
    .sidebar-menu::-webkit-scrollbar {
        width: 6px;
    }
    
    .sidebar-menu::-webkit-scrollbar-track {
        background: rgba(255, 255, 255, 0.1);
        border-radius: 3px;
    }
    
    .sidebar-menu::-webkit-scrollbar-thumb {
        background: rgba(52, 152, 219, 0.5);
        border-radius: 3px;
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
    }
    
    .sidebar-menu::-webkit-scrollbar-thumb:hover {
        background: rgba(52, 152, 219, 0.7);
    }
</style> 