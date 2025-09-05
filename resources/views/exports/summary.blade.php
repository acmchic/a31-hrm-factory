<table>
    <thead>
    <tr>
        <th align=center style="font-size: 16px; font-weight: 600;">Mã số</th>
        <th align=center style="font-size: 16px; font-weight: 600;">Họ và tên</th>
        <th align=center style="font-size: 16px; font-weight: 600;">Tỷ lệ làm việc</th>
        <th align=center style="font-size: 16px; font-weight: 600;">Số dư nghỉ phép</th>
        <th align=center style="font-size: 16px; font-weight: 600;">Đếm đi muộn</th>
        <th align=center style="font-size: 16px; font-weight: 600;">Đếm theo giờ</th>
        <th align=center style="font-size: 16px; font-weight: 600;">Khấu trừ</th>
        <th align=center style="font-size: 16px; font-weight: 600;">Khấu trừ tiền</th>
    </tr>
    </thead>
    <tbody>
    @foreach($exportedSummary as $employee)
        <tr>
            <td bgcolor=green align=center style="border: 3px solid #CCC;">{{ $employee->id }}</td>
            <td bgcolor=green align=center style="border: 3px solid #CCC;">{{ $employee->full_name }}</td>
            <td bgcolor=green align=center style="border: 3px solid #CCC;">{{ $employee->work_rate ?? 100 }}</td>
            <td bgcolor=green align=center style="border: 3px solid #CCC;">{{ $employee->balance_leave_allowed . "/" . $employee->max_leave_allowed }}</td>
            <td bgcolor=green align=center style="border: 3px solid #CCC;">{{ $employee->delay_counter }}</td>
            <td bgcolor=green align=center style="border: 3px solid #CCC;">{{ $employee->hourly_counter }}</td>
            <td bgcolor=gray align=center style="border: 3px solid #CCC;">{{ count($employee->discounts) }}</td>
            <td @if ( $employee->cash_discounts_count != 0 ) bgcolor=red @else bgcolor=gray @endif align=center style="border: 3px solid #CCC;">{{ $employee->cash_discounts_count }}</td>
        </tr>
        <tr>
          <td colspan=8></td>
        </tr>
        <tr>
          <td colspan=4></td>
          <td bgcolor=yellow align=center style="border: 3px solid #CCC; font-size: 16px">STT</td>
          <td bgcolor=yellow align=center style="border: 3px solid #CCC; font-size: 16px">Ngày</td>
          <td bgcolor=yellow align=center style="border: 3px solid #CCC; font-size: 16px">Tỷ lệ</td>
          <td bgcolor=yellow align=center style="border: 3px solid #CCC; font-size: 16px">Lý do</td>
        </tr>
        @foreach($employee->discounts as $discount)
          <tr>
            <td colspan=4></td>
            <td align=center style="border: 3px dashed #CCC;">{{ $loop->iteration }}</td>
            <td align=center>{{ $discount->date }}</td>
            <td bgcolor=orange align=center class="text-center">
              <div class="badge bg-label-danger me-1">
                {{ $discount->rate }}
              </div>
            </td>
            <td>
              {{ $discount->reason }}
              @if ($discount->is_auto)
                <span class="badge badge-center rounded-pill bg-label-secondary" data-bs-toggle="tooltip" data-bs-placement="top" data-bs-custom-class="tooltip-primary" data-bs-original-title="Automatic"><i class="ti ti-settings"></i></span>
              @endif
            </td>
          </tr>
        @endforeach
        <tr>
          <td colspan=8></td>
        </tr>
    @endforeach
    </tbody>
</table>
