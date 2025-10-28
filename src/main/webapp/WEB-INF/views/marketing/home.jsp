<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>PeriDesk — Dental Clinic Management Software</title>
    <meta name="description" content="PeriDesk helps dental clinics run efficiently with scheduling, patient management, payments, and analytics — all in one modern platform.">
    <meta name="keywords" content="dental clinic software, patient management, appointment scheduling, dental analytics, clinic payments">
    <link rel="canonical" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/" />
    <meta property="og:title" content="PeriDesk — Dental Clinic Management Software">
    <meta property="og:description" content="Run your dental clinic with ease: appointments, patients, payments, and insights.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
    <meta property="og:image" content="https://images.unsplash.com/photo-1588771930293-0c1cb9b3ef6e?w=1200&q=80&auto=format&fit=crop">
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="PeriDesk — Dental Clinic Management Software">
    <meta name="twitter:description" content="Operate smarter with PeriDesk: efficient scheduling, patient records, and payments.">

    <link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/marketing.css">

    <script>
      // Structured Data (JSON-LD)
      window.addEventListener('DOMContentLoaded', function () {
        var jsonLd = {
          "@context": "https://schema.org",
          "@type": "SoftwareApplication",
          "name": "PeriDesk",
          "applicationCategory": "BusinessApplication",
          "operatingSystem": "Web",
          "description": "Dental clinic management platform for appointments, patient records, and payments.",
          "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
          "publisher": {"@type": "Organization", "name": "PeriDesk"}
        };
        var script = document.createElement('script');
        script.type = 'application/ld+json';
        script.text = JSON.stringify(jsonLd);
        document.head.appendChild(script);
      });
    </script>

    <script defer src="${pageContext.request.contextPath}/js/marketing.js"></script>
</head>
<body>
    <header class="site-header" role="banner" aria-label="Site header">
        <jsp:include page="/WEB-INF/views/marketing/partials/header.jsp" />
    </header>

    <main id="main" class="site-main" role="main">
        <section class="hero" aria-label="Hero section">
            <jsp:include page="/WEB-INF/views/marketing/partials/hero.jsp" />
        </section>

        <section class="stats" aria-label="Outcome metrics">
            <jsp:include page="/WEB-INF/views/marketing/partials/stats.jsp" />
        </section>

        <section class="features" aria-label="Key features">
            <jsp:include page="/WEB-INF/views/marketing/partials/features.jsp" />
        </section>

        <section class="testimonials" aria-label="Testimonials">
            <jsp:include page="/WEB-INF/views/marketing/partials/testimonials.jsp" />
        </section>

        <section class="cta" aria-label="Call to action">
            <jsp:include page="/WEB-INF/views/marketing/partials/cta.jsp" />
        </section>
    </main>

    <footer class="site-footer" role="contentinfo" aria-label="Footer">
        <jsp:include page="/WEB-INF/views/marketing/partials/footer.jsp" />
    </footer>
</body>
</html>