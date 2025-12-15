import { X, Calendar, User, CreditCard, Receipt } from 'lucide-react';
import { Order, OrderItem } from '../../lib/supabase';

interface OrderDetailModalProps {
  order: Order;
  orderItems: OrderItem[];
  onClose: () => void;
}

export function OrderDetailModal({ order, orderItems, onClose }: OrderDetailModalProps) {
  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return new Intl.DateTimeFormat('id-ID', {
      day: 'numeric',
      month: 'long',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    }).format(date);
  };

  const getPaymentMethodLabel = (method: string) => {
    const labels: Record<string, string> = {
      cash: 'Tunai',
      card: 'Kartu',
      ewallet: 'E-Wallet',
    };
    return labels[method] || method;
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50 overflow-y-auto">
      <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-2xl max-w-2xl w-full my-8">
        <div className="flex items-center justify-between p-6 border-b border-gray-200 dark:border-gray-700">
          <div>
            <h2 className="text-2xl font-bold text-gray-900 dark:text-white flex items-center gap-2">
              <Receipt className="w-6 h-6" />
              Detail Transaksi
            </h2>
            <p className="text-sm text-gray-500 dark:text-gray-400 mt-1 font-mono">
              {order.order_number}
            </p>
          </div>
          <button
            onClick={onClose}
            className="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        <div className="p-6">
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-6">
            <div className="bg-gray-50 dark:bg-gray-700 rounded-lg p-4">
              <div className="flex items-center gap-2 text-gray-600 dark:text-gray-400 mb-2">
                <Calendar className="w-4 h-4" />
                <span className="text-sm font-medium">Waktu</span>
              </div>
              <p className="text-sm text-gray-900 dark:text-white font-semibold">
                {formatDate(order.created_at)}
              </p>
            </div>

            <div className="bg-gray-50 dark:bg-gray-700 rounded-lg p-4">
              <div className="flex items-center gap-2 text-gray-600 dark:text-gray-400 mb-2">
                <User className="w-4 h-4" />
                <span className="text-sm font-medium">Pelanggan</span>
              </div>
              <p className="text-sm text-gray-900 dark:text-white font-semibold">
                {order.customer_name || 'Guest'}
              </p>
            </div>

            <div className="bg-gray-50 dark:bg-gray-700 rounded-lg p-4">
              <div className="flex items-center gap-2 text-gray-600 dark:text-gray-400 mb-2">
                <CreditCard className="w-4 h-4" />
                <span className="text-sm font-medium">Pembayaran</span>
              </div>
              <p className="text-sm text-gray-900 dark:text-white font-semibold">
                {getPaymentMethodLabel(order.payment_method)}
              </p>
            </div>
          </div>

          <div className="border-t border-gray-200 dark:border-gray-700 pt-6">
            <h3 className="font-semibold text-gray-900 dark:text-white mb-4">
              Item Pesanan
            </h3>
            <div className="space-y-3">
              {orderItems.map((item) => (
                <div
                  key={item.id}
                  className="flex justify-between items-center bg-gray-50 dark:bg-gray-700 rounded-lg p-4"
                >
                  <div className="flex-1">
                    <p className="font-semibold text-gray-900 dark:text-white">
                      {item.product_name}
                    </p>
                    <p className="text-sm text-gray-600 dark:text-gray-400">
                      Rp {item.price.toLocaleString('id-ID')} x {item.quantity}
                    </p>
                  </div>
                  <p className="font-bold text-gray-900 dark:text-white">
                    Rp {item.subtotal.toLocaleString('id-ID')}
                  </p>
                </div>
              ))}
            </div>
          </div>

          <div className="border-t border-gray-200 dark:border-gray-700 mt-6 pt-6">
            <div className="flex justify-between items-center">
              <span className="text-lg font-bold text-gray-900 dark:text-white">
                Total Pembayaran
              </span>
              <span className="text-2xl font-bold text-blue-600 dark:text-blue-400">
                Rp {order.total_amount.toLocaleString('id-ID')}
              </span>
            </div>
          </div>
        </div>

        <div className="p-6 border-t border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-700">
          <button
            onClick={onClose}
            className="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3 px-6 rounded-lg transition duration-200 shadow-lg hover:shadow-xl"
          >
            Tutup
          </button>
        </div>
      </div>
    </div>
  );
}
