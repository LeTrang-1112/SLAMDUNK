<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class GioHang extends Model
{
    use HasFactory;
    protected $table = 'giohang';
    protected $primaryKey = 'GioHangId';
    protected $keyType = 'int';
    public $timestamps = false;
    protected $fillable = [
        'GioHangId',
        'NguoiDungId',
        'TongTien',
        'NgayTao',
    ];
    public function nguoiDung()
    {
        return $this->belongsTo(NguoiDung::class, 'NguoiDungId');
    }

    public function chiTietGioHangs()
    {
        return $this->hasMany(ChiTietGioHang::class, 'GioHangId');
    }
}
