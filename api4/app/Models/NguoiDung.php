<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class NguoiDung extends Model
{
    use HasFactory;
    protected $table = 'nguoidung';
    protected $primaryKey = 'NguoiDungId';
    protected $keyType = 'int';
    public $timestamps = false;
    protected $fillable = [
        'NguoiDungId',
        'TenNguoiDung',
        'Email',
        'SoDienThoai',
        'MatKhau',
        'DiaChi',
        'NgayTao',
        'IsAdmin',
    ];

    public function gioHangs()
    {
        return $this->hasMany(GioHang::class, 'NguoiDungId');
    }

    public function donHangs()
    {
        return $this->hasMany(DonHang::class, 'NguoiDungId');
    }

    public function phongChats()
    {
        return $this->hasMany(PhongChat::class, 'NguoiDungId');
    }
    
}
