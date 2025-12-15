import { Moon, Sun, LogOut, ShoppingBag, History, Package } from 'lucide-react';
import { useTheme } from '../../contexts/ThemeContext';
import { useAuth } from '../../contexts/AuthContext';

interface HeaderProps {
  currentPage: 'pos' | 'products' | 'history';
  onPageChange: (page: 'pos' | 'products' | 'history') => void;
}

export function Header({ currentPage, onPageChange }: HeaderProps) {
  const { theme, toggleTheme } = useTheme();
  const { signOut, user } = useAuth();

  return (
    <header className="bg-white dark:bg-gray-800 shadow-lg border-b border-gray-200 dark:border-gray-700 sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          <div className="flex items-center gap-3">
            <div className="bg-blue-600 rounded-lg p-2">
              <span className="text-2xl">☕</span>
            </div>
            <div>
              <h1 className="text-xl font-bold text-gray-900 dark:text-white">
                BadeTeh POS
              </h1>
              <p className="text-xs text-gray-500 dark:text-gray-400">
                {user?.email}
              </p>
            </div>
          </div>

          <nav className="hidden md:flex items-center gap-2">
            <button
              onClick={() => onPageChange('pos')}
              className={`flex items-center gap-2 px-4 py-2 rounded-lg font-medium transition ${
                currentPage === 'pos'
                  ? 'bg-blue-600 text-white'
                  : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'
              }`}
            >
              <ShoppingBag className="w-5 h-5" />
              <span>Kasir</span>
            </button>
            <button
              onClick={() => onPageChange('products')}
              className={`flex items-center gap-2 px-4 py-2 rounded-lg font-medium transition ${
                currentPage === 'products'
                  ? 'bg-blue-600 text-white'
                  : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'
              }`}
            >
              <Package className="w-5 h-5" />
              <span>Produk</span>
            </button>
            <button
              onClick={() => onPageChange('history')}
              className={`flex items-center gap-2 px-4 py-2 rounded-lg font-medium transition ${
                currentPage === 'history'
                  ? 'bg-blue-600 text-white'
                  : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'
              }`}
            >
              <History className="w-5 h-5" />
              <span>Riwayat</span>
            </button>
          </nav>

          <div className="flex items-center gap-2">
            <button
              onClick={toggleTheme}
              className="p-2 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 transition"
              aria-label="Toggle theme"
            >
              {theme === 'light' ? <Moon className="w-5 h-5" /> : <Sun className="w-5 h-5" />}
            </button>
            <button
              onClick={() => signOut()}
              className="flex items-center gap-2 px-4 py-2 rounded-lg text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/30 transition font-medium"
            >
              <LogOut className="w-5 h-5" />
              <span className="hidden sm:inline">Keluar</span>
            </button>
          </div>
        </div>

        <nav className="md:hidden flex items-center gap-2 pb-3 overflow-x-auto">
          <button
            onClick={() => onPageChange('pos')}
            className={`flex items-center gap-2 px-4 py-2 rounded-lg font-medium transition whitespace-nowrap ${
              currentPage === 'pos'
                ? 'bg-blue-600 text-white'
                : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'
            }`}
          >
            <ShoppingBag className="w-5 h-5" />
            <span>Kasir</span>
          </button>
          <button
            onClick={() => onPageChange('products')}
            className={`flex items-center gap-2 px-4 py-2 rounded-lg font-medium transition whitespace-nowrap ${
              currentPage === 'products'
                ? 'bg-blue-600 text-white'
                : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'
            }`}
          >
            <Package className="w-5 h-5" />
            <span>Produk</span>
          </button>
          <button
            onClick={() => onPageChange('history')}
            className={`flex items-center gap-2 px-4 py-2 rounded-lg font-medium transition whitespace-nowrap ${
              currentPage === 'history'
                ? 'bg-blue-600 text-white'
                : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'
            }`}
          >
            <History className="w-5 h-5" />
            <span>Riwayat</span>
          </button>
        </nav>
      </div>
    </header>
  );
}
