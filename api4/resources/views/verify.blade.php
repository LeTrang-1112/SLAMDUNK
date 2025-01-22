@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row">
        <div class="col-md-8">
            <h1>Chào mừng bạn đến với trang chủ</h1>

            <!-- Kiểm tra trạng thái xác thực email -->
            @if (Auth::user()->hasVerifiedEmail())
                <p>Chào mừng bạn, {{ Auth::user()->TenNguoiDung }}!</p>
                <p>Bạn đã xác thực email và có thể sử dụng tất cả các tính năng của ứng dụng.</p>
            @else
                <p>Vui lòng xác thực email của bạn để sử dụng tất cả các tính năng.</p>
                <form class="d-inline" method="POST" action="{{ route('verification.resend') }}">
                    @csrf
                    <button type="submit" class="btn btn-link p-0 m-0 align-baseline">Nhấn vào đây để yêu cầu lại email xác thực.</button>
                </form>
            @endif

        </div>
    </div>
</div>
@endsection
