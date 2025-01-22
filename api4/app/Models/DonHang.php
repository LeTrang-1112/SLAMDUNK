<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DonHang extends Model
{
    use HasFactory;
    protected $table = 'donhang';
    protected $primaryKey = 'DonHangId';
    protected $keyType = 'int';
    public $timestamps = false;
    protected $fillable = [
        'NguoiDungId',
        'TongTien',
        'PhuongThucThanhToan',
        'TrangThai',
        'DiaChiGiaoHang',
        'GhiChu',
        'NgayDatHang',
        'SoDienThoai',
        'NguoiNhan'
    ];

    public function nguoiDung()
    {
        return $this->belongsTo(NguoiDung::class, 'NguoiDungId');
    }

    public function chiTietDonHangs()
    {
        return $this->hasMany(ChiTietDonHang::class, 'DonHangId');
    }
}
