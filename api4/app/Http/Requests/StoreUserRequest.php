<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreUserRequest extends FormRequest
{
    public function authorize()
    {
        return true; // Cho phép truy cập vào request này
    }

    public function rules()
    {
        return [
            'TenNguoiDung' => 'required|string|max:100',
            'Email' => 'required|email|unique:NguoiDung,Email',
            'SoDienThoai' => 'nullable|string|max:15',
            'MatKhau' => 'required|string|min:6',
            'DiaChi' => 'nullable|string|max:255',
        ];
    }

    public function messages()
    {
        return [
            'Email.required' => 'Email là bắt buộc.',
            'Email.email' => 'Email không hợp lệ.',
            'Email.unique' => 'Email đã tồn tại trong hệ thống.',
        ];
    }
}
