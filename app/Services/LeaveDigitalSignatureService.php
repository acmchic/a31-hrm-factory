<?php

namespace App\Services;

use App\Models\EmployeeLeave;
use App\Models\Employee;
use App\Models\User;
use TCPDF;
use Illuminate\Support\Facades\Log;

class LeaveDigitalSignatureService extends BaseDigitalSignatureService
{
  public function signLeaveRequest(EmployeeLeave $leaveRequest, User $signer, $certificatePath = null)
  {
    try {
      $leaveRequest->update([
        'status' => 'approved',
        'workflow_status' => 'approved',
        'approved_by' => $signer->id,
        'approved_at' => now(),
      ]);

      $unsignedPdf = $this->generateLeaveRequestPDF($leaveRequest, false);
      $signedContent = $this->signPdfBinary($unsignedPdf);

      $relativePath = "leaves/don_xin_nghi_phep_{$leaveRequest->id}_signed.pdf";
      $this->storeSignedPdf($signedContent, $relativePath);

      // Save signer info and uploaded signature image path for rendering on PDF
      $signatureData = [
        'approved_by' => $signer->name,
        'approved_at' => now()->toISOString(),
        'signature_path' => $signer->signature_path, // relative path under public disk
      ];

      $leaveRequest->update([
        'digital_signature' => json_encode($signatureData)
      ]);

      return $signedContent;
    } catch (\Exception $e) {
      Log::error('Error signing leave request: ' . $e->getMessage());
      throw $e;
    }
  }

  public function generateLeaveRequestPDF($leaveRequest, bool $autoSignIfApproved = true)
  {
    try {
      $pdf = new TCPDF('P', 'mm', 'A4', true, 'UTF-8', false);

      $pdf->SetCreator('Hệ thống HRMS');
      $pdf->SetAuthor('HRMS');
      $pdf->SetTitle('Đơn xin nghỉ phép - ' . $leaveRequest->id);
      $pdf->SetSubject('Đơn xin nghỉ phép');

      $pdf->SetMargins(20, 20, 20);
      $pdf->SetAutoPageBreak(TRUE, 25);

      $pdf->AddPage();

      $logoPath = public_path('assets/img/logo/logo.png');
      if (file_exists($logoPath)) {
        $pdf->Image($logoPath, 85, 10, 40, 20, '', '', '', false, 300, '', false, false, 0);
      }

      $pdf->SetY(35);
      $pdf->SetFont('dejavusans', 'B', 16);
      $pdf->Cell(0, 10, 'ĐƠN XIN NGHỈ PHÉP', 0, 1, 'C');

      $html = $this->generateLeaveRequestHTMLContent($leaveRequest);
      $pdf->writeHTML($html, true, false, true, false, '');

      if ($autoSignIfApproved && ($leaveRequest->status === 'approved')) {
        $this->addLeaveSignatureToPDF($pdf, $leaveRequest);
      }

      $content = $pdf->Output('', 'S');

      if ($autoSignIfApproved && ($leaveRequest->status === 'approved')) {
        return $this->signPdfBinary($content);
      }

      return $content;
    } catch (\Exception $e) {
      Log::error('Error generating leave request PDF: ' . $e->getMessage());
      throw $e;
    }
  }

  private function generateLeaveRequestHTMLContent($leaveRequest)
  {
    // Map theo yêu cầu: employee_id trong employee_leave trỏ tới users.id
    $accountUser = User::find($leaveRequest->employee_id);
    // Lấy employee theo user_id để có phòng ban và chức vụ
    $employee = Employee::where('user_id', $accountUser?->id)
      ->with(['department', 'position'])
      ->first();
    if (!$employee && $accountUser?->name) {
      $employee = Employee::where('name', $accountUser->name)
        ->with(['department', 'position'])
        ->first();
    }
    $leave = $leaveRequest->leave;

    $html = '
    <style>
        body { font-family: dejavusans, sans-serif; }
        h2.title { text-align: center; font-size: 18pt; font-weight: bold; margin-bottom: 15px; }
        h4.subtitle { text-align: center; font-size: 11pt; margin-bottom: 25px; color: #444; }

        .info-table { width: 100%; border-collapse: collapse; margin: 15px 0; font-size: 10pt; }
        .info-table th, .info-table td { padding: 10px; border: 1px solid #bbb; }
        .info-table th { background-color: #f2f2f2; text-align: left; width: 30%; font-weight: bold; }

        .signature-block { margin-top: 40px; text-align: center; }
        .signature-box { border: 1px dashed #999; height: 80px; width: 200px; margin: 0 auto 10px auto; }
        .signature-label { font-size: 9pt; color: #555; }

        .history-section { margin-top: 40px; }
        .history-section h4 { font-size: 11pt; margin-bottom: 8px; }
        .history-item { font-size: 9pt; margin-bottom: 6px; }
        .history-item span { color: #555; }
    </style>

    <h2 class="title">ĐƠN XIN NGHỈ PHÉP</h2>
    <h4 class="subtitle">Trung tâm chỉ huy điều hành sản xuất - Nhà Máy A31</h4>

    <table class="info-table">
        <tr>
            <th>Họ và tên</th>
            <td>' . ($accountUser->name ?? 'N/A') . '</td>
        </tr>
        <tr>
            <th>Mã nhân viên</th>
            <td>' . ($accountUser->username ?? 'N/A') . '</td>
        </tr>
        <tr>
            <th>Phòng ban</th>
            <td>' . ($employee?->department?->name ?? 'N/A') . '</td>
        </tr>
        <tr>
            <th>Chức vụ</th>
            <td>' . ($employee?->position?->name ?? 'N/A') . '</td>
        </tr>
        <tr>
            <th>Loại nghỉ phép</th>
            <td>' . ($leave->name ?? 'N/A') . '</td>
        </tr>
        <tr>
            <th>Từ ngày</th>
            <td>' . ($leaveRequest->from_date ? \Carbon\Carbon::parse($leaveRequest->from_date)->format('d/m/Y') : 'N/A') . '</td>
        </tr>
        <tr>
            <th>Đến ngày</th>
            <td>' . ($leaveRequest->to_date ? \Carbon\Carbon::parse($leaveRequest->to_date)->format('d/m/Y') : 'N/A') . '</td>
        </tr>
        <tr>
            <th>Số ngày nghỉ</th>
            <td>' . (($leaveRequest->from_date && $leaveRequest->to_date) ? (\Carbon\Carbon::parse($leaveRequest->from_date)->diffInDays(\Carbon\Carbon::parse($leaveRequest->to_date)) + 1) : 'N/A') . ' ngày</td>
        </tr>
        <tr>
            <th>Lý do nghỉ phép</th>
            <td>' . ($leaveRequest->note ?? 'N/A') . '</td>
        </tr>
        <tr>
            <th>Ngày tạo đơn</th>
            <td>' . ($leaveRequest->created_at ? $leaveRequest->created_at->format('d/m/Y H:i') : 'N/A') . '</td>
        </tr>
    </table>

    <div class="signature-block">';

    if ($leaveRequest->digital_signature) {
      $signature = json_decode($leaveRequest->digital_signature, true);
      $html .= '<div class="signature-box" style="display: flex; align-items: center; justify-content: center; background-color: #f9f9f9;">';
      $html .= '<div style="text-align: center;">';
      $html .= '<div style="font-weight: bold; font-size: 12pt; margin-bottom: 5px;">' . ($signature['approved_by'] ?? 'Chưa ký') . '</div>';
      $html .= '<div style="font-size: 9pt; color: #666;">' . (isset($signature['approved_at']) ? \Carbon\Carbon::parse($signature['approved_at'])->format('d/m/Y H:i') : 'Chưa duyệt') . '</div>';
      $html .= '</div>';
      $html .= '</div>';
    } else {
      $html .= '<div class="signature-box"></div>';
    }

    $html .= '<div class="signature-label">Chữ ký của người duyệt</div>
    </div>

    <div class="history-section">
        <h4>Lịch sử ký số</h4>';

    if ($leaveRequest->digital_signature) {
      $signature = json_decode($leaveRequest->digital_signature, true);
      $html .= '
        <div class="history-item">• Người duyệt: <span>' . ($signature['approved_by'] ?? 'Chưa ký') . '</span></div>
        <div class="history-item">• Thời gian: <span>' . (isset($signature['approved_at']) ? \Carbon\Carbon::parse($signature['approved_at'])->format('d/m/Y H:i') : 'Chưa duyệt') . '</span></div>';
    } else {
      $html .= '<div class="history-item"><span>Chưa có dữ liệu ký số</span></div>';
    }

    $html .= '
        <div class="history-item">• Chữ ký số A1: <span>A31 Factory Digital Signing</span></div>
        <div class="history-item">• Thời gian ký: <span>' . now()->format('d/m/Y H:i') . '</span></div>
    </div>';

    return $html;
  }


  private function addLeaveSignatureToPDF($pdf, $leaveRequest)
  {
    // Đặt chữ ký ở góc phải trên cùng thay vì ở dưới
    $this->addTopRightSignatureToLeave($pdf, $leaveRequest);
  }

  /**
   * Thêm chữ ký trực quan ở góc phải trên cùng của trang với tên Trưởng phòng bên dưới
   */
  private function addTopRightSignatureToLeave($pdf, $leaveRequest)
  {
    $approver = null;
    $signaturePath = null;

    // Lấy thông tin người phê duyệt từ digital_signature hoặc approved_by
    if ($leaveRequest->digital_signature) {
      $signature = json_decode($leaveRequest->digital_signature, true);
      if (isset($signature['signature_path']) && !empty($signature['signature_path'])) {
        $signaturePath = storage_path('app/public/' . $signature['signature_path']);
        if (file_exists($signaturePath)) {
          $approverName = $signature['approved_by'] ?? 'Trưởng phòng';
        }
      }
    }

    // Fallback: lấy từ approved_by nếu không có trong digital_signature
    if (!$signaturePath && $leaveRequest->approved_by) {
      $approver = User::find($leaveRequest->approved_by);
      if ($approver && $approver->signature_path) {
        $sigPath = storage_path('app/public/' . $approver->signature_path);
        if (file_exists($sigPath)) {
          $signaturePath = $sigPath;
          $approverName = $approver->name;
        }
      }
    }

    if (!$signaturePath) {
      return; // Không có chữ ký để hiển thị
    }

    // Vị trí góc phải trên - tính toán cho khổ A4 (210mm width)
    $pageWidth = 210; // mm
    $rightMargin = 20; // mm  
    $imageWidth = 40; // mm
    $x = $pageWidth - $rightMargin - $imageWidth; // ~150mm từ lề trái
    $y = 35; // Dưới header một chút

    // Vẽ ảnh chữ ký
    $pdf->Image($signaturePath, $x, $y, $imageWidth, 0, '', '', '', false, 300, '', false, false, 0);

    // Ghi tên Trưởng phòng bên dưới ảnh chữ ký
    $pdf->SetFont('dejavusans', '', 9);
    $pdf->SetXY($x, $y + 24); // 24mm dưới ảnh
    $pdf->Cell($imageWidth, 6, $approverName ?? 'Trưởng phòng', 0, 0, 'C');
  }

  private function addLeaveSignatureHistoryToPDF($pdf, $leaveRequest, $yPosition)
  {
    if ($yPosition > 250) {
      $pdf->AddPage();
      $yPosition = 40;
    }

    $pdf->SetXY(20, $yPosition);
    $pdf->SetFont('dejavusans', 'B', 10);
    $pdf->Cell(0, 8, 'Lịch sử ký số', 0, 1, 'L');

    $pdf->SetXY(20, $yPosition + 8);
    $pdf->Cell(170, 0.5, '', 0, 1, 'L', true);

    $yPosition += 15;

    if ($leaveRequest->digital_signature) {
      $signature = json_decode($leaveRequest->digital_signature, true);
      $pdf->SetXY(20, $yPosition);
      $pdf->SetFont('dejavusans', '', 9);
      $pdf->Cell(0, 6, '• Người duyệt: ' . ($signature['approved_by'] ?? 'Chưa ký'), 0, 1, 'L');
      $pdf->SetXY(20, $yPosition + 6);
      $pdf->SetFont('dejavusans', '', 8);
      $date = isset($signature['approved_at']) && !empty($signature['approved_at'])
        ? \Carbon\Carbon::parse($signature['approved_at'])->format('d/m/Y H:i')
        : 'Chưa duyệt';
      $pdf->Cell(0, 5, '  Thời gian: ' . $date, 0, 1, 'L');
      $yPosition += 15;
    }

    $pdf->SetXY(20, $yPosition);
    $pdf->SetFont('dejavusans', '', 9);
    $pdf->Cell(0, 6, '• Chữ ký số A1: A31 Factory Digital Signing', 0, 1, 'L');
    $pdf->SetXY(20, $yPosition + 6);
    $pdf->SetFont('dejavusans', '', 8);
    $pdf->Cell(0, 5, '  Thời gian ký: ' . now()->format('d/m/Y H:i'), 0, 1, 'L');
  }

  protected function getSignatureReason(): string
  {
    return 'Ký số tài liệu đơn nghỉ phép';
  }
}
