using System;
using Atol.Drivers10.Fptr;

class Program
{
    static void Main()
    {
        // Создаём экземпляр драйвера ККТ
        Fptr fptr = new Fptr();

        try
        {
            // Открываем соединение с ККТ
            fptr.open();

            // Проверяем, установлено ли соединение
            if (!fptr.isOpened())
            {
                Console.WriteLine("Ошибка: Не удалось подключиться к ККТ.");
                return;
            }

            // Проверяем, открыта ли смена
            fptr.setParam(Constants.LIBFPTR_PARAM_DATA_TYPE, Constants.LIBFPTR_DT_SHIFT_STATE);
            fptr.queryData();

            int shiftState = (int)fptr.getParamInt(Constants.LIBFPTR_PARAM_SHIFT_STATE);

            if (shiftState == Constants.LIBFPTR_SS_OPENED)
            {
                Console.WriteLine("Смена уже открыта. Завершаем работу.");
                return;
            }

            // Запрашиваем текущие дату и время ККТ
            fptr.setParam(Constants.LIBFPTR_PARAM_DATA_TYPE, Constants.LIBFPTR_DT_DATE_TIME);
            fptr.queryData();

            DateTime kktDateTime = fptr.getParamDateTime(Constants.LIBFPTR_PARAM_DATE_TIME);

            // Получаем системное время ПК
            DateTime pcDateTime = DateTime.Now;

            // Сравниваем разницу во времени
            TimeSpan timeDifference = pcDateTime - kktDateTime;
            if (Math.Abs(timeDifference.TotalSeconds) > 60)
            {
                // Если разница больше 1 минуты, устанавливаем новое время в ККТ
                fptr.setParam(Constants.LIBFPTR_PARAM_DATE_TIME, pcDateTime);
                fptr.writeDateTime();

                Console.WriteLine("Время ККТ обновлено. Новое время: " + pcDateTime.ToString("yyyy.MM.dd HH:mm:ss"));
            }
            else
            {
                Console.WriteLine("Время ККТ синхронизировано с ПК. Обновление не требуется.");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine("Ошибка: " + ex.Message);
        }
        finally
        {
            // Закрываем соединение с ККТ, если оно открыто
            if (fptr.isOpened())
            {
                fptr.close();
            }
        }
    }
}
