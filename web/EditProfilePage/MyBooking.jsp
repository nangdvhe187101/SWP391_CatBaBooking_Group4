<%-- 
    Document   : MyBooking
    Purpose    : Simple, clean "My Booking" page for end users
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Booking - Cát Bà Booking</title>

    <!-- FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        /* ===== Root variables ===== */
        :root { 
            --bg:#f7fafc; 
            --card:#ffffff; 
            --text:#1f2937; 
            --muted:#64748b; 
            --primary:#059669; 
            --border:#e5e7eb; 
        }

        * { box-sizing: border-box; }

        body { 
            margin: 0; 
            font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial; 
            background: var(--bg); 
            color: var(--text); 
        }

        /* ===== Layout ===== */
        .container { 
            max-width: 960px; 
            margin: 40px auto; 
            padding: 0 16px; 
        }

        .card { 
            background: var(--card); 
            border: 1px solid var(--border); 
            border-radius: 12px; 
            box-shadow: 0 8px 24px rgba(0,0,0,.04); 
        }

        .card-header { 
            padding: 20px 24px; 
            border-bottom: 1px solid var(--border); 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
        }

        .title { font-size: 20px; font-weight: 700; margin: 0; }
        .subtitle { color: var(--muted); font-size: 14px; margin: 0; }

        .content { padding: 16px 24px; }

        .header { 
            text-align: center; 
            margin-bottom: 20px; 
            position: relative; 
        }

        .header-actions {
            position: absolute;
            left: 24px;
            top: 50%;
            transform: translateY(-50%);
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            background: #f8f9fa;
            color: #6c757d;
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            border: 1px solid #dee2e6;
            transition: all 0.3s ease;
        }

        .btn-back:hover {
            background: #e9ecef;
            color: #495057;
            text-decoration: none;
        }

        /* ===== Table ===== */
        .table { 
            width: 100%; 
            border-collapse: collapse; 
        }

        .table th, 
        .table td { 
            padding: 14px 16px; 
            text-align: left; 
            border-bottom: 1px solid var(--border); 
            vertical-align: middle; 
        }

        .table th { 
            color: var(--muted); 
            font-weight: 600; 
            font-size: 13px; 
            background: #fafafa; 
        }

        .actions { 
            display: flex; 
            flex-wrap: wrap; 
            gap: 8px; 
        }

        /* ===== Buttons ===== */
        .btn { 
            appearance: none; 
            border: 1px solid var(--border); 
            background: #fff; 
            color: var(--text); 
            padding: 8px 12px; 
            border-radius: 8px; 
            font-size: 14px; 
            cursor: pointer; 
            transition: 0.2s;
        }

        .btn:hover { border-color: #cbd5e1; }
        .btn.primary { background: var(--primary); color: #fff; border-color: var(--primary); }
        .btn.primary:hover { opacity: 0.9; }

        .empty { 
            padding: 24px; 
            color: var(--muted); 
            text-align: center; 
        }

        /* ===== Feedback Section ===== */
        .feedback { 
            margin-top: 20px; 
            padding: 20px; 
            background: #ffffff; 
            border: 1px solid var(--border); 
            border-radius: 12px; 
        }

        .feedback h2 { 
            font-size: 18px; 
            margin: 0 0 8px 0; 
        }

        .feedback .hint { 
            color: var(--muted); 
            font-size: 13px; 
            margin-bottom: 12px; 
        }

        textarea { 
            width: 100%; 
            min-height: 90px; 
            padding: 10px 12px; 
            border: 1px solid var(--border); 
            border-radius: 8px; 
            resize: vertical; 
            font-family: inherit; 
            font-size: 14px; 
        }

        .feedback .row { 
            display: grid; 
            grid-template-columns: 1fr auto; 
            gap: 10px; 
            align-items: start; 
        }

        .feedback .submit { padding: 10px 14px; }

        /* ===== Responsive ===== */
        @media (max-width: 640px) {
            .table thead { display: none; }
            .table, .table tbody, .table tr, .table td { display: block; width: 100%; }
            .table tr { background: #fff; margin: 8px 0; border: 1px solid var(--border); border-radius: 10px; }
            .table td { border-bottom: 0; padding: 12px 16px; }
            .table td[data-label]::before { content: attr(data-label) ": "; color: var(--muted); font-weight: 600; }
        }
    </style>
</head>

<body>
    <div class="container">
        <!-- ===== Header ===== -->
        <div class="header">
            <div class="header-actions">
                <a class="btn-back" href="${pageContext.request.contextPath}/HomePage/Home.jsp">
                    <i class="fas fa-arrow-left"></i> Quay lại trang chủ
                </a>
            </div>
            <h1 style="margin:0; font-size:24px; font-weight:700; color:#1f2937;">
                My Booking
            </h1>
        </div>

        <!-- ===== Card Wrapper ===== -->
        <div class="card">
            <div class="card-header">
                <p class="subtitle">Danh sách đặt chỗ của bạn.</p>
            </div>

            <div class="content">
                <!-- ===== Booking Table ===== -->
                <table class="table" aria-label="My Booking Table">
                    <thead>
                        <tr>
                            <th style="width: 20%">Ngày</th>
                            <th style="width: 20%">Thời gian</th>
                            <th style="width: 15%">Số lượng</th>
                            <th style="width: 25%">Hình thức</th>
                            <th style="width: 20%"></th>
                        </tr>
                    </thead>

                    <tbody>
                        <tr>
                            <td data-label="Ngày">12/11/2025</td>
                            <td data-label="Thời gian">14:00 - 16:00</td>
                            <td data-label="Số lượng">4</td>
                            <td data-label="Hình thức">Nhà hàng</td>
                            <td data-label="">
                                <div class="actions">
                                    <button class="btn primary" type="button">
                                        Xem chi tiết <i class="fas fa-chevron-right" style="font-size:12px;"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>

                        <tr>
                            <td data-label="Ngày">25/11/2025</td>
                            <td data-label="Thời gian">Cả ngày</td>
                            <td data-label="Số lượng">2</td>
                            <td data-label="Hình thức">Homestay</td>
                            <td data-label="">
                                <div class="actions">
                                    <button class="btn primary" type="button">
                                        Xem chi tiết <i class="fas fa-chevron-right" style="font-size:12px;"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- ===== Empty State (optional for future dynamic data) ===== -->
                <%-- <div class="empty">Bạn chưa có đặt chỗ nào.</div> --%>

                <!-- ===== Feedback Section ===== -->
                <div id="fb1" class="feedback" aria-label="Feedback">
                    <h2>Feedback</h2>
                    <div class="hint">
                        Hãy chia sẻ cảm nhận để chúng tôi cải thiện dịch vụ.
                    </div>
                    <div class="row">
                        <textarea placeholder="Viết cảm nhận của bạn... (tối đa 500 ký tự)"></textarea>
                        <button class="btn submit btn-save" type="button">Gửi</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
    
    </script>
</body>
</html>
